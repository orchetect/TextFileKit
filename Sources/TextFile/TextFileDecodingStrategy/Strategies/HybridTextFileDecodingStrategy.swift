//
//  HybridTextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import protocol Foundation.DataProtocol
import class Foundation.FileManager
import class Foundation.NSNumber
import class Foundation.NSString
import struct Foundation.ObjCBool
import struct Foundation.URL
import struct Foundation.UUID
#else
import class Foundation.NSString
import struct Foundation.ObjCBool
import struct FoundationEssentials.Data
import protocol FoundationEssentials.DataProtocol
import class FoundationEssentials.FileManager
import struct FoundationEssentials.URL
import struct FoundationEssentials.UUID
#endif

/// Hybrid text file decoding strategy.
public struct HybridTextFileDecodingStrategy {
    /// If `true`, allow lossy text decoding if decoding can't be detected automatically.
    public var allowLossy: Bool
    
    public var convertLineEndings: Bool
    
    public init(
        allowLossy: Bool = true,
        convertLineEndings: Bool = true
    ) {
        self.allowLossy = allowLossy
        self.convertLineEndings = convertLineEndings
    }
}

extension HybridTextFileDecodingStrategy: Equatable { }

extension HybridTextFileDecodingStrategy: Hashable { }

extension HybridTextFileDecodingStrategy: Sendable { }

extension HybridTextFileDecodingStrategy: TextFileDecodingStrategy {
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> PlainTextFile {
        var decoded = try decodeTextHybrid(in: data, fileURL: nil)
        if convertLineEndings { decoded.content = decoded.content.fixedLineBreaks }
        return decoded
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> PlainTextFile {
        var decoded = try decodeTextHybrid(in: data, fileURL: fileURL)
        if convertLineEndings { decoded.content = decoded.content.fixedLineBreaks }
        return decoded
    }
    
    public func decodeText(fileURL: URL) throws(TextFileDecodeError) -> PlainTextFile {
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            throw .fileReadError(underlyingError: error)
        }
        return try decodeText(in: data, fileURL: fileURL)
    }
}

// MARK: - Decoding Heuristics

extension HybridTextFileDecodingStrategy {
    /// Main hybrid decoding trunk method.
    func decodeTextHybrid(in data: Data, fileURL: URL?) throws(TextFileDecodeError) -> PlainTextFile {
        var data = data
        
        // Step 1: try detecting a BOM, if present
        if let decoded = try decodeTextUsingBOM(in: data) {
            return decoded
        }
        
        // Step 2:
        // if UTF-8 BOM is present, but text failed to decode, remove the BOM from the parsable data.
        // once in a rare while, a BOM is inserted at the start of a file that it doesn't
        // belong in. we can try decoding the file once more after stripping out the BOM.
        if let bom = data.byteOrderMarkPrefix, bom == .utf8 {
            data = data[data.startIndex.advanced(by: bom.bytes.count)...]
        }
        
        // Step 3: try UTF-8 without BOM
        if let decoded = try decodeUTF8(in: data) {
            return decoded
        }
        
        // Step 4: attempt to detect UTF-16 / UTF-32 that may be missing a BOM
        if let decoded = try decodeTextGuessingMultiByteUTFEncoding(in: data) {
            return decoded
        }
        
        // Step 5: try ISO-8859-1 (ISO Latin-1)
        if let decoded = try decodeISOLatin1(in: data) {
            return decoded
        }
        
        // Step 6: try Windows-12520 or MacRoman
        if let decoded = try decodeWindows1252OrMacRoman(in: data) {
            return decoded
        }
        
        // Step 7: attempt to detect encoding using Standard Lib / Foundation API
        var heldError: TextFileDecodeError? = nil
        do throws(TextFileDecodeError) {
            return try decodeTextAutomatically(allowLossy: allowLossy, in: data, fileURL: fileURL)
        } catch {
            heldError = error
        }
        
        // Step 8: all options have been exhausted, so throw an error
        throw heldError ?? .unrecognizedTextEncoding
    }
    
    func decodeTextUsingBOM(
        ignoring ignoredBOMs: Set<ByteOrderMark> = [],
        in data: Data
    ) throws(TextFileDecodeError) -> PlainTextFile? {
        guard let bom = data.byteOrderMarkPrefix
        else { return nil }
        
        guard !ignoredBOMs.contains(bom)
        else { return nil }
        
        let sourceData: Data = if bom == .utf8, data.count >= ByteOrderMark.utf8.bytes.count {
            // strip UTF-8 BOM because String decoding API doesn't like it
            data[data.startIndex.advanced(by: ByteOrderMark.utf8.bytes.count)...]
        } else {
            data
        }
        
        guard let text = String(data: sourceData, encoding: bom.encoding)
        else { return nil }
        
        return PlainTextFile(content: text, encoding: bom.encoding)
    }
    
    func decodeTextAutomatically(
        allowLossy: Bool,
        in data: Data,
        fileURL: URL?
    ) throws(TextFileDecodeError) -> PlainTextFile {
        let decoded: PlainTextFile
        let decoding: any TextFileDecodingStrategy = .bestNonHybridForCurrentPlatform(allowLossy: allowLossy)
        if let fileURL {
            decoded = try decoding.decodeText(in: data, fileURL: fileURL)
        } else {
            decoded = try decoding.decodeText(in: data)
        }
        return decoded
    }
    
    func decodeTextGuessingMultiByteUTFEncoding(
        in data: Data
    ) throws(TextFileDecodeError) -> PlainTextFile? {
        guard let possibleEncoding = data.guessMultiByteUTFEncoding(),
              let text = String(data: data, encoding: possibleEncoding)
        else { return nil }
        
        return PlainTextFile(content: text, encoding: possibleEncoding)
    }
    
    func decodeUTF8(
        in data: Data
    ) throws(TextFileDecodeError) -> PlainTextFile? {
        guard let text = String(data: data, encoding: .utf8) else {
            return nil
        }
        return PlainTextFile(content: text, encoding: .utf8)
    }
    
    /// ISO-8859-1 (isoLatin1 case of String.Encoding)
    ///
    /// The ASCII table, when defined according to the ISO-8859-1 character encoding (also known
    /// as iso-ir-100, csISOLatin1, latin1, l1, IBM819, CP819), includes ASCII control characters
    /// and ASCII printable characters. Moreover, it also includes the extended ASCII character
    /// set unique to ISO-8859-1. This character set is particularly designed to support
    /// Latin1/Western European languages.
    ///
    /// See https://stackoverflow.com/a/64276978/2805570
    func decodeISOLatin1(
        in data: Data
    ) throws(TextFileDecodeError) -> PlainTextFile? {
        // It's not trivial to do binary regex in Swift, so since we're only looking for byte ranges
        // we can use a non-regex solution to detect or count bytes in certain ranges.
        
        // let notISO8859 = #"[\x00-\x06\x0B\x0E-\x1A\x1C-\x1F\x7F\x80-\x84\x86-\x9F]"#
        let byteRangesNotUsedInISO8859: [ClosedRange<UInt8>] = [
            0x00 ... 0x06, 0x0B ... 0x0B, 0x0E ... 0x1A, 0x1C ... 0x1F, 0x7F ... 0x7F, 0x80 ... 0x84, 0x86 ... 0x9F
        ]
        
        // if any of these bytes are present, it's not ISO-8859-1
        guard !data.contains(anyElementsIn: byteRangesNotUsedInISO8859) else {
            return nil
        }
        
        // try decoding
        guard let text = String(data: data, encoding: .isoLatin1) else {
            return nil
        }
        
        return PlainTextFile(content: text, encoding: .isoLatin1)
    }
    
    /// # How do you distinguish MacRoman from CP1252?
    ///
    /// # Undefined characters
    ///
    /// The bytes 0x81, 0x8D, 0x8F, 0x90, 0x9D are not used in CP1252. If they occur, then assume the data is MacRoman.
    ///
    /// # Identical characters
    ///
    /// The bytes 0xA2 (`¢`), 0xA3 (`£`), 0xA9 (`©`), 0xB1 (`±`), 0xB5 (`µ`) happen to be the same in both encodings.
    /// If these are the only non-ASCII bytes, then it doesn't matter whether you choose MacRoman or CP1252.
    ///
    /// # Statistical approach
    ///
    /// Count character (NOT byte!) frequencies in the data you know to be UTF-8.
    /// Determine the most frequent characters.
    /// Then use this data to determine whether the CP1252 or MacRoman characters are more common.
    ///
    /// For example, in a search I just performed on 100 random English Wikipedia articles,
    /// the most common non-ASCII characters are `·•–é°®’èö—`. Based on this fact,
    ///
    /// - The bytes 0x92, 0x95, 0x96, 0x97, 0xAE, 0xB0, 0xB7, 0xE8, 0xE9, or 0xF6 suggest Windows-1252.
    /// - The bytes 0x8E, 0x8F, 0x9A, 0xA1, 0xA5, 0xA8, 0xD0, 0xD1, 0xD5, or 0xE1 suggest MacRoman.
    ///
    /// Count up the CP1252-suggesting bytes and the MacRoman-suggesting bytes, and go with whichever is greatest.
    ///
    /// See https://stackoverflow.com/a/4200765/2805570
    func decodeWindows1252OrMacRoman(
        in data: Data
    ) throws(TextFileDecodeError) -> PlainTextFile? {
        // It's not trivial to do binary regex in Swift, so since we're only looking for byte ranges
        // we can use a non-regex solution to detect or count bytes in certain ranges.
        
        // let notIn1BYTE = #"[\x00-\x06\x0B\x0E-\x1A\x1C-\x1F\x7F]"#
        let byteRangesNotIn1Byte: [ClosedRange<UInt8>] = [
            0x00 ... 0x06, 0x0B ... 0x0B, 0x0E ... 0x1A, 0x1C ... 0x1F, 0x7F ... 0x7F
        ]
        
        // if any of these bytes are present, it's neither CP1252 nor MacRoman
        guard !data.contains(anyElementsIn: byteRangesNotIn1Byte) else {
            return nil
        }
        
        // let notInCP1252 = #"[\x81\x8D\x8F\x90\x9D]"#
        let bytesNotInCP1252: [UInt8] = [0x81, 0x8D, 0x8F, 0x90, 0x9D]
        
        // if any of these bytes are present, it's not CP1252
        let isNotCP1252 = data.contains(anyElementsIn: bytesNotInCP1252)
        
        // let cp1252CharBytes = #"[\x92\x95\x96\x97\xAE\xB0\xB7\xE8\xE9\xF6]"#
        let cp1252CharBytes: [UInt8] = [0x92, 0x95, 0x96, 0x97, 0xAE, 0xB0, 0xB7, 0xE8, 0xE9, 0xF6]
        let cp1252CharBytesCount = data.count(ofElementsIn: cp1252CharBytes)
        
        // let macRomanCharBytes = #"[\x8E\x8F\x9A\xA1\xA5\xA8\xD0\xD1\xD5\xE1]"#
        let macRomanCharBytes: [UInt8] = [0x8E, 0x8F, 0x9A, 0xA1, 0xA5, 0xA8, 0xD0, 0xD1, 0xD5, 0xE1]
        let macRomanCharBytesCount = data.count(ofElementsIn: macRomanCharBytes)
        
        if !isNotCP1252, (macRomanCharBytesCount < cp1252CharBytesCount) {
            // Likely Windows-1252
            guard let text = String(data: data, encoding: .windowsCP1252) else {
                return nil
            }
            return PlainTextFile(content: text, encoding: .windowsCP1252)
        } else {
            // MacRoman
            guard let text = String(data: data, encoding: .macOSRoman) else {
                return nil
            }
            return PlainTextFile(content: text, encoding: .macOSRoman)
        }
    }
}

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == HybridTextFileDecodingStrategy {
    /// Returns the best text file decoding method for the current platform.
    public static func hybrid(allowLossy: Bool = true) -> HybridTextFileDecodingStrategy {
        HybridTextFileDecodingStrategy(allowLossy: allowLossy)
    }
}

extension TextFileDecodingStrategy where Self == AnyTextFileDecodingStrategy {
    fileprivate static func bestNonHybridForCurrentPlatform(allowLossy: Bool) -> AnyTextFileDecodingStrategy {
        #if canImport(Darwin)
        return AnyTextFileDecodingStrategy(.nsString(allowLossy: allowLossy))
        #else
        return AnyTextFileDecodingStrategy(.string())
        #endif
    }
}
