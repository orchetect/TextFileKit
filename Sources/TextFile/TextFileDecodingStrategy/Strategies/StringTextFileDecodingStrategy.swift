//
//  StringTextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import protocol Foundation.DataProtocol
import class Foundation.FileManager
import class Foundation.NSNumber
import class Foundation.NSString
import struct Foundation.URL
import struct Foundation.UUID
#else
import class Foundation.NSString
import struct FoundationEssentials.Data
import protocol FoundationEssentials.DataProtocol
import class FoundationEssentials.FileManager
import struct FoundationEssentials.URL
import struct FoundationEssentials.UUID
#endif

/// String-based text file encoding detection.
/// This method is available on all platforms, but requires writing the text file data to disk if it does
/// not already exist as a file.
public struct StringTextFileDecodingStrategy {
    public var convertLineEndings: Bool
    
    public init(convertLineEndings: Bool = true) {
        self.convertLineEndings = convertLineEndings
    }
}

extension StringTextFileDecodingStrategy: TextFileDecodingStrategy {
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> DecodedTextFile {
        let (textFileURL, isTemporaryFile) = try writeTemporaryFileIfNecessary(data: data, fileURL: nil)
        
        defer {
            // cleanup file on disk
            if isTemporaryFile { try? FileManager.default.removeItem(at: textFileURL) }
        }
        
        return try decodeText(in: data, fileURL: textFileURL)
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
        do {
            var usedEncoding: String.Encoding = .utf8
            let text = try String(contentsOfFile: fileURL.path, usedEncoding: &usedEncoding)
            let encoding = usedEncoding
            var decoded = DecodedTextFile(content: text, encoding: encoding, url: nil)
            if convertLineEndings { decoded.content = decoded.content.fixedLineBreaks }
            return decoded
        } catch {
            throw .fileReadError(underlyingError: error)
        }
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

// MARK: - Utilities

extension StringTextFileDecodingStrategy {
    func writeTemporaryFileIfNecessary(data: Data, fileURL: URL?) throws(TextFileDecodeError) -> (url: URL, isTemporary: Bool) {
        if let fileURL,
           let (isExists, isDirectory) = fileURL.fileURLStatus,
           isExists,
           !isDirectory
        {
            // file URL is valid and usable
            return (url: fileURL, isTemporary: false)
        } else {
            // write out to a file on disk, as this String API requires reading from a file
            let temporaryFileURL: URL = .temporaryDirectoryBackCompat
                .appendingPathComponent("\(UUID().uuidString).txt")
            do {
                try data.write(to: temporaryFileURL)
            } catch {
                throw .fileWriteError(underlyingError: error)
            }
            return (url: temporaryFileURL, isTemporary: true)
        }
    }
}

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == StringTextFileDecodingStrategy {
    /// NSString-based text file encoding detection.
    /// This method is only available on Apple platforms.
    public static func string(convertLineEndings: Bool = true) -> StringTextFileDecodingStrategy {
        StringTextFileDecodingStrategy(convertLineEndings: convertLineEndings)
    }
}
