//
//  PlainTextFile.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import Foundation
#else
import FoundationEssentials
#endif

public struct PlainTextFile {
    /// Decoded text file content.
    public internal(set) var content: String
    
    /// The source text file encoding.
    public internal(set) var encoding: String.Encoding
    
    /// The file URL, if the text file was read from disk.
    /// If the file was read from memory (`Data`), this property will be `nil`.
    public internal(set) var url: URL?
    
    /// Initialize by directly populating properties.
    /// No decoding occurs when using this initializer.
    public init(content: String, encoding: String.Encoding, url: URL? = nil) {
        self.content = content
        self.encoding = encoding
        self.url = url
    }
}

extension PlainTextFile: Equatable { }

extension PlainTextFile: Hashable { }

extension PlainTextFile: Sendable { }

// MARK: - URL Init

extension PlainTextFile {
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

extension PlainTextFile {
    /// Attempt to decode raw text file contents.
    ///
    /// - Parameters:
    ///   - data: Raw (encoded) text file content.
    ///   - encoding: Optionally supply a text encoding if it is known.
    ///     If decoding fails or this parameter is `nil`, a hybrid auto-detection strategy will be used to attempt
    ///     to auto-detect the text encoding.
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
    ///
    /// - Parameters:
    ///   - data: Raw (encoded) text file content.
    ///   - strategy: Text encoding auto-detection heuristic (strategy). Hyrbid (default) is recommended and will
    ///     produce the best results.
    ///   - encoding: Optionally supply a text encoding if it is known.
    ///     If decoding fails or this parameter is `nil`, the auto-detection strategy will be used to attempt to
    ///     auto-detect the text encoding.
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

// MARK: - Data

extension PlainTextFile {
    /// Returns the text encoded into data using the assigned ``encoding``.
    ///
    /// - Parameters:
    ///   - includeBOM: When `true`, if the text encoding carries a byte order mark (BOM), it will be inserted at
    ///     the head of the file. For UTF-8 it is not always necessary, but some applications such as Excel will
    ///     not correctly identify the text encoding without it. For UTF-16 and UTF-32 it is highly recommended.
    public func data(includeBOM: Bool = true) throws(TextFileEncodeError) -> Data {
        guard var data = content.data(using: encoding) else {
            throw .encodingFailed(underlyingError: nil)
        }
        
        if let bom = encoding.byteOrderMark {
            if includeBOM {
                if !data.starts(with: bom.data) {
                    // add only if BOM is not present
                    data.insert(contentsOf: bom.data, at: 0)
                }
            } else {
                // remove BOM if present
                if data.starts(with: bom.data) {
                    data.removeFirst(bom.data.count)
                }
            }
        }
        
        return data
    }
}

// MARK: - Write

extension PlainTextFile {
    /// Write the text to a file on disk using the assigned ``encoding``.
    ///
    /// - Parameters:
    ///   - file: Output file URL.
    ///   - includeBOM: When `true`, if the text encoding carries a byte order mark (BOM), it will be inserted at
    ///     the head of the file. For UTF-8 it is not always necessary, but some applications such as Excel will
    ///     not correctly identify the text encoding without it. For UTF-16 and UTF-32 it is highly recommended.
    public func write(to file: URL, includeBOM: Bool = true) throws(TextFileEncodeError) {
        let data = try data(includeBOM: includeBOM)
        
        do {
            try data.write(to: file)
        } catch {
            throw .encodingFailed(underlyingError: error)
        }
    }
}
