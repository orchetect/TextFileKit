//
//  PlainTextFile+Decode.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import Foundation
#else
import FoundationEssentials
#endif

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
        
        let strategy: any TextFileDecodingStrategy = .default()
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
        
        let strategy: any TextFileDecodingStrategy = .default()
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
