//
//  Data Extensions.swift
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

extension Data {
    enum StringDecodeStrategy: Equatable, Hashable, Sendable {
        case nsString
        case string
        
        static func bestForCurrentPlatform(preferring preference: Self? = nil) -> Self {
            #if canImport(Darwin)
            preference ?? .nsString
            #else
            .string
            #endif
        }
    }
    
    /// Attempts to decode raw text file content.
    ///
    /// - Parameters:
    ///   - strategy: Preferred encoding detection strategy. If the preferred strategy is `nil` or is
    ///     not available, most appropriate strategy for the current platform will be used.
    ///   - encoding: Preferred encoding. If the preferred encoding is `nil`, the encoding will be
    ///     attempted to be detected.
    ///   - file: This parameter is only used on non-Apple platforms.
    ///     If the data was read from a file on disk, supply the file URL.
    ///     If use of the file is required, it will be read if the file exists on disk.
    ///     Otherwise, a temporary file will be created in the system temporary folder.
    ///
    /// - Returns: The decoded string and string encoding if successful.
    func decodeString(
        strategy preferredStrategy: StringDecodeStrategy? = nil,
        encoding preferredEncoding: String.Encoding? = nil,
        file: URL? = nil
    ) throws(TextFileDecodeError) -> (string: String, encoding: String.Encoding) {
        var text: String
        var encoding: String.Encoding
        
        let strategy: StringDecodeStrategy = .bestForCurrentPlatform(preferring: preferredStrategy)
        
        // try decoding with the preferred encoding, if supplied
        if let preferredEncoding,
           let rawValue = String(data: self, encoding: preferredEncoding)
        {
            text = rawValue
            encoding = preferredEncoding
        }
        // otherwise, detect BOM, if present
        else if let bom = byteOrderMarkPrefix,
                bom != .utf8, // UTF-8 with BOM will be decoded by the auto-detecting API
                let rawValue = String(data: self, encoding: bom.encoding)
        {
            text = rawValue
            encoding = bom.encoding
        }
        // otherwise, attempt to detect encoding if BOM is not present
        else {
            do throws(TextFileDecodeError) {
                switch strategy {
                case .nsString:
                    #if canImport(Darwin)
                    // Apple platforms
                    // (`NSString.stringEncoding()` is not available on non-Apple platforms)

                    var usedLossyConversion: ObjCBool = false // TODO: not used
                    var nsString: NSString?
                    guard case let rawValue = NSString.stringEncoding(
                        for: self,
                        encodingOptions: nil,
                        convertedString: &nsString,
                        usedLossyConversion: &usedLossyConversion
                    ),
                        rawValue != 0,
                        let rawText = nsString as? String
                    else {
                        throw .unrecognizedTextEncoding
                    }
                    encoding = String.Encoding(rawValue: rawValue)
                    text = rawText
                    #else
                    // this should never happen, but throw error just in case
                    throw .unrecognizedTextEncoding
                    #endif

                case .string:
                    // non-Apple platforms
                    
                    let textFileURL: URL
                    var isDirectory = ObjCBool(false)
                    if let file,
                       FileManager.default.fileExists(atPath: file.path, isDirectory: &isDirectory),
                       !isDirectory.boolValue
                    {
                        // use the supplied file path if it exists
                        textFileURL = file
                    } else {
                        // write out to a file on disk, as this String API requires reading from a file
                        textFileURL = .temporaryDirectoryBackCompat
                            .appendingPathComponent("\(UUID().uuidString).txt")
                        do {
                            try self.write(to: textFileURL)
                        } catch {
                            throw .fileWriteError(underlyingError: error)
                        }
                    }
                    
                    do {
                        var usedEncoding: String.Encoding = .utf8
                        text = try String(contentsOfFile: textFileURL.path, usedEncoding: &usedEncoding)
                        encoding = usedEncoding
                    } catch {
                        throw .fileReadError(underlyingError: error)
                    }
                }
            } catch {
                // as a last ditch effort, attempt to detect UTF-16 / UTF-32 that may be missing a BOM
                guard let possibleEncoding = guessMultiByteUTFEncoding(),
                      let rawValue = String(data: self, encoding: possibleEncoding)
                else {
                    throw error // re-throw error
                }
                
                text = rawValue
                encoding = possibleEncoding
            }
        }
        
        return (string: text, encoding: encoding)
    }
    
    /// Basic naïve heuristic to attempt to detect byte order (endianness) in multi-byte UTF (UTF-16, UTF-32) encoded data.
    /// This method assumes there is no BOM present at the start of the data.
    func guessMultiByteUTFEncoding() -> String.Encoding? {
        let sampleBytes = self.prefix(100)
        guard sampleBytes.count >= 2 else { return nil }
        
        func splitBytes(byteWidth: Int) -> (left: [Data.Element], right: [Data.Element])? {
            let leftBytes = sampleBytes.enumerated()
                .compactMap { $0.offset.isMultiple(of: byteWidth) ? $0.element : nil }
            let rightBytes = sampleBytes.enumerated()
                .compactMap { ($0.offset - (byteWidth - 1)).isMultiple(of: byteWidth) ? $0.element : nil }
            
            guard !leftBytes.isEmpty, !rightBytes.isEmpty else { return nil }
            
            return (left: leftBytes, right: rightBytes)
        }
        
        enum Endianness {
            case bigEndian
            case littleEndian
        }
        
        func probableEndianness(highBytes: some DataProtocol, lowBytes: some DataProtocol) -> Bool {
            // UTF-16/32 typically have a 0x00 byte as the high byte of each 2 or 4-byte cluster
            
            let zeroHighByteCount = highBytes.filter { $0 == 0x00 }.count
            let percentageOfHighBytesThatAreZero = Double(zeroHighByteCount) / Double(highBytes.count)
            
            let nonZeroLowByteCount = lowBytes.filter { $0 != 0x00 }.count
            let percentageOfLowBytesThatAreNonZero = Double(nonZeroLowByteCount) / Double(lowBytes.count)
            
            let thresholdPercentage: Double = 0.8 // arbitrary: 80% or more
            
            return (percentageOfHighBytesThatAreZero > thresholdPercentage)
                && (percentageOfLowBytesThatAreNonZero > thresholdPercentage)
        }
        
        func isProbablyUTF(byteWidth: Int) -> Endianness? {
            guard let (leftBytes, rightBytes) = splitBytes(byteWidth: byteWidth)
            else { return nil }
            
            if probableEndianness(highBytes: leftBytes, lowBytes: rightBytes) {
                return .bigEndian
            } else if probableEndianness(highBytes: rightBytes, lowBytes: leftBytes) {
                return .littleEndian
            } else {
                return nil
            }
        }
        
        func isProbablyUTF16() -> Endianness? {
            isProbablyUTF(byteWidth: 2)
        }
        
        func isProbablyUTF32() -> Endianness? {
            isProbablyUTF(byteWidth: 4)
        }
        
        if let endianness = isProbablyUTF16() {
            switch endianness {
            case .bigEndian: return .utf16BigEndian
            case .littleEndian: return .utf16LittleEndian
            }
        } else if let endianness = isProbablyUTF32() {
            switch endianness {
            case .bigEndian: return .utf32BigEndian
            case .littleEndian: return .utf32LittleEndian
            }
        } else {
            return nil
        }
    }
}
