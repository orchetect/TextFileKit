//
//  ExplicitTextFileDecodingStrategy.swift
//  swift-textfile
//
//  Created by Steffan Andrews on 2026-03-27.
//

#if canImport(Darwin)
import struct Foundation.Data
import struct Foundation.URL
#else
import struct FoundationEssentials.Data
import struct FoundationEssentials.URL
#endif

/// Explicit text decoding using a specified encoding.
public struct ExplicitTextFileDecodingStrategy {
    public var convertLineEndings: Bool
    
    /// Text encoding to use while decoding.
    public var encoding: String.Encoding
    
    public init(encoding: String.Encoding, convertLineEndings: Bool = true) {
        self.encoding = encoding
        self.convertLineEndings = convertLineEndings
    }
}

extension ExplicitTextFileDecodingStrategy: TextFileDecodingStrategy {
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> DecodedTextFile {
        guard var text = String(data: data, encoding: encoding)
        else { throw .invalidTextEncoding }
        
        if convertLineEndings { text = text.fixedLineBreaks }
        
        return DecodedTextFile(content: text, encoding: encoding, url: nil)
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
        var decoded = try decodeText(in: data)
        decoded.url = fileURL
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

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == ExplicitTextFileDecodingStrategy {
    /// NSString-based text file encoding detection.
    /// This method is only available on Apple platforms.
    public static func string(encoding: String.Encoding, convertLineEndings: Bool = true) -> ExplicitTextFileDecodingStrategy {
        ExplicitTextFileDecodingStrategy(encoding: encoding, convertLineEndings: convertLineEndings)
    }
}
