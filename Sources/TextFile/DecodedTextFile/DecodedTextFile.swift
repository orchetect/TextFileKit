//
//  DecodedTextFile.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import Foundation
#else
import FoundationEssentials
#endif

public struct DecodedTextFile {
    /// Decoded text file content.
    public internal(set) var content: String
    
    /// The source text file encoding.
    public internal(set) var encoding: String.Encoding
    
    /// The file URL, if the text file was read from disk.
    /// If the file was read from memory (`Data`), this property may be `nil`.
    public internal(set) var url: URL?
    
    /// Initialize by directly populating properties.
    /// No decoding occurs when using this initializer.
    public init(content: String, encoding: String.Encoding, url: URL? = nil) {
        self.content = content
        self.encoding = encoding
        self.url = url
    }
}

extension DecodedTextFile: Equatable { }

extension DecodedTextFile: Hashable { }

extension DecodedTextFile: Sendable { }

// MARK: - URL Init

extension DecodedTextFile {
    /// Attempt to decode a text file on disk at the specified file URL.
    public init(
        url: URL,
        preferring encoding: String.Encoding? = nil
    ) throws(TextFileDecodeError) {
        // first attempt decoding with preferred encoding
        if let encoding,
           let decoded = try? ExplicitTextFileDecodingStrategy(encoding: encoding).decodeText(fileURL: url)
        {
            self = decoded
            return
        }
        
        let strategy: TextFileDecodingStrategy = .default()
        self = try strategy.decodeText(fileURL: url)
    }
    
    /// Attempt to decode a text file on disk at the specified file URL.
    public init(
        url: URL,
        strategy: some TextFileDecodingStrategy,
        preferring encoding: String.Encoding? = nil
    ) throws(TextFileDecodeError) {
        // first attempt decoding with preferred encoding
        if let encoding,
           let decoded = try? ExplicitTextFileDecodingStrategy(encoding: encoding).decodeText(fileURL: url)
        {
            self = decoded
            return
        }
        
        self = try strategy.decodeText(fileURL: url)
    }
}

// MARK: - Data Init

extension DecodedTextFile {
    /// Attempt to decode raw text file contents.
    public init(
        data: Data,
        preferring encoding: String.Encoding? = nil
    ) throws(TextFileDecodeError) {
        // first attempt decoding with preferred encoding
        if let encoding,
           let decoded = try? ExplicitTextFileDecodingStrategy(encoding: encoding).decodeText(in: data)
        {
            self = decoded
            return
        }
        
        let strategy: TextFileDecodingStrategy = .default()
        self = try strategy.decodeText(in: data)
    }
    
    /// Attempt to decode raw text file contents.
    public init(
        data: Data,
        strategy: some TextFileDecodingStrategy,
        preferring encoding: String.Encoding? = nil
    ) throws(TextFileDecodeError) {
        // first attempt decoding with preferred encoding
        if let encoding,
           let decoded = try? ExplicitTextFileDecodingStrategy(encoding: encoding).decodeText(in: data)
        {
            self = decoded
            return
        }
        
        self = try strategy.decodeText(in: data)
    }
}
