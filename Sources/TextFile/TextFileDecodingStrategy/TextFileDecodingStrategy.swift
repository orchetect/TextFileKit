//
//  TextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import struct Foundation.URL
#else
import struct FoundationEssentials.Data
import struct FoundationEssentials.URL
#endif

/// Text file decode strategy.
public protocol TextFileDecodingStrategy: Sendable { // TODO: make Equatable and Hashable
    /// Option flag determining whether line endings should be converted to line endings appropriate
    /// for the current platform if necessary.
    var convertLineEndings: Bool { get set }
    
    /// Attempt to decode text from raw text file content in memory.
    func decodeText(in data: Data) throws(TextFileDecodeError) -> PlainTextFile
    
    /// Attempt to decode text from raw text file content in memory that was read from a file on disk.
    func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> PlainTextFile
    
    /// Attempt to decode the contents of a text file on disk.
    func decodeText(fileURL: URL) throws(TextFileDecodeError) -> PlainTextFile
}
