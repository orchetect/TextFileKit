//
//  ExplicitTextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
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

extension ExplicitTextFileDecodingStrategy: Equatable { }

extension ExplicitTextFileDecodingStrategy: Hashable { }

extension ExplicitTextFileDecodingStrategy: Sendable { }

extension ExplicitTextFileDecodingStrategy: TextFileDecodingStrategy {
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> PlainTextFile {
        // first try String API
        if var text = String(data: data, encoding: encoding) {
            if convertLineEndings { text = text.fixedLineBreaks }
            return PlainTextFile(content: text, encoding: encoding)
        }
        
        // then try NSString API, if available
        #if canImport(Darwin)
        if let decoded = try? NSStringTextFileDecodingStrategy(
            allowLossy: false,
            suggestedEncodings: [encoding],
            convertLineEndings: convertLineEndings
        )
        .decodeText(in: data) {
            return decoded
        }
        #endif
        
        // otherwise, throw error
        throw .invalidTextEncoding
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> PlainTextFile {
        try decodeText(in: data)
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

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == ExplicitTextFileDecodingStrategy {
    /// NSString-based text file encoding detection.
    /// This method is only available on Apple platforms.
    public static func string(encoding: String.Encoding, convertLineEndings: Bool = true) -> ExplicitTextFileDecodingStrategy {
        ExplicitTextFileDecodingStrategy(encoding: encoding, convertLineEndings: convertLineEndings)
    }
}
