//
//  HybridTextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
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
    public var convertLineEndings: Bool
    
    public init(convertLineEndings: Bool = true) {
        self.convertLineEndings = convertLineEndings
    }
}

extension HybridTextFileDecodingStrategy: Sendable { }

extension HybridTextFileDecodingStrategy: TextFileDecodingStrategy {
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> DecodedTextFile {
        var decoded = try decodeTextHybrid(in: data, fileURL: nil)
        if convertLineEndings { decoded.content = decoded.content.fixedLineBreaks }
        return decoded
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
        var decoded = try decodeTextHybrid(in: data, fileURL: fileURL)
        if convertLineEndings { decoded.content = decoded.content.fixedLineBreaks }
        return decoded
    }
    
    public func decodeText(fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
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
    func decodeTextHybrid(in data: Data, fileURL: URL?) throws(TextFileDecodeError) -> DecodedTextFile {
        // Step 1: try detecting a BOM, if present
        // UTF-8 with BOM will be decoded by the auto-detecting API after this step, so ignore it at this stage
        if let decoded = try decodeTextUsingBOM(ignoring: [.utf8], in: data, fileURL: fileURL) {
            return decoded
        }
        
        // Step 2: attempt to detect encoding if BOM is not present
        var heldError: TextFileDecodeError? = nil
        do throws(TextFileDecodeError) {
            let decoded = try decodeTextAutomatically(allowLossy: false, in: data, fileURL: fileURL)
            return decoded
        } catch {
            heldError = error
        }
        
        // Step 3: attempt to detect UTF-16 / UTF-32 that may be missing a BOM
        if let decoded = try decodeTextGuessingMultiByteUTFEncoding(in: data, fileURL: fileURL) {
            return decoded
        }
        
        // Step 4:
        // once in a rare while, a BOM is inserted at the start of a file that it doesn't
        // belong in. we can try decoding the file once more after stripping out the BOM.
        if let decoded = try decodeTextAutomaticallyAfterRemovingBOM(in: data, fileURL: fileURL) {
            return decoded
        }
        
        // Step 5: all options have been exhausted, so throw an error
        throw heldError ?? .unrecognizedTextEncoding
    }

    func decodeTextUsingPreferredEncoding(
        encoding: String.Encoding?,
        in data: Data,
        fileURL: URL?
    ) throws(TextFileDecodeError) -> DecodedTextFile? {
        guard let encoding,
              let rawValue = String(data: data, encoding: encoding)
        else { return nil }
        
        return DecodedTextFile(content: rawValue, encoding: encoding, url: fileURL)
    }
    
    func decodeTextUsingBOM(
        ignoring ignoredBOMs: Set<ByteOrderMark> = [],
        in data: Data,
        fileURL: URL?
    ) throws(TextFileDecodeError) -> DecodedTextFile? {
        guard let bom = data.byteOrderMarkPrefix
        else { return nil }
        
        guard !ignoredBOMs.contains(bom)
        else { return nil }
        
        guard let rawValue = String(data: data, encoding: bom.encoding)
        else { return nil }
        
        return DecodedTextFile(content: rawValue, encoding: bom.encoding, url: fileURL)
    }
    
    func decodeTextAutomatically(
        allowLossy: Bool,
        in data: Data,
        fileURL: URL?
    ) throws(TextFileDecodeError) -> DecodedTextFile {
        let decoded: DecodedTextFile
        let decoding: TextFileDecodingStrategy = .bestNonHybridForCurrentPlatform(allowLossy: allowLossy)
        if let fileURL {
            decoded = try decoding.decodeText(in: data, fileURL: fileURL)
        } else {
            decoded = try decoding.decodeText(in: data)
        }
        return decoded
    }
    
    func decodeTextGuessingMultiByteUTFEncoding(
        in data: Data,
        fileURL: URL?
    ) throws(TextFileDecodeError) -> DecodedTextFile? {
        guard let possibleEncoding = data.guessMultiByteUTFEncoding(),
              let rawValue = String(data: data, encoding: possibleEncoding)
        else { return nil }
        
        return DecodedTextFile(content: rawValue, encoding: possibleEncoding, url: fileURL)
    }
    
    func decodeTextAutomaticallyAfterRemovingBOM(
        in data: Data,
        fileURL: URL?
    ) throws(TextFileDecodeError) -> DecodedTextFile? {
        guard let bom = data.byteOrderMarkPrefix
        else { return nil }

        let dataWithoutBOM = data[data.startIndex.advanced(by: bom.bytes.count)...]

        let lossyDecoding: TextFileDecodingStrategy = .bestNonHybridForCurrentPlatform(allowLossy: true)
        var decoded: DecodedTextFile = try lossyDecoding.decodeText(in: dataWithoutBOM) // DON'T pass file URL in
        
        decoded.url = fileURL
        return decoded
    }
}

// MARK: - Utilities

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == AnyTextFileDecodingStrategy {
    fileprivate static func bestNonHybridForCurrentPlatform(allowLossy: Bool) -> AnyTextFileDecodingStrategy {
        #if canImport(Darwin)
        return AnyTextFileDecodingStrategy(.nsString(allowLossy: allowLossy))
        #else
        return AnyTextFileDecodingStrategy(.string())
        #endif
    }
}


// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == HybridTextFileDecodingStrategy {
    /// Returns the best text file decoding method for the current platform.
    public static func hybrid() -> HybridTextFileDecodingStrategy {
        HybridTextFileDecodingStrategy()
    }
}
