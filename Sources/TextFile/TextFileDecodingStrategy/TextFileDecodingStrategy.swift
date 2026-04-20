//
//  TextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import struct Foundation.URL
#else
import struct FoundationEssentials.Data
import struct FoundationEssentials.URL
#endif

/// Text file decode strategy.
public protocol TextFileDecodingStrategy: Equatable, Hashable, Sendable {
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

// MARK: - Equatable Default Implementation

extension TextFileDecodingStrategy {
    /// Returns `true` if the two text file decoding strategy instances are equal.
    public func isEqual(to other: any TextFileDecodingStrategy) -> Bool {
        AnyHashable(self) == AnyHashable(other)
    }
}

@_disfavoredOverload
public func == (lhs: any TextFileDecodingStrategy, rhs: any TextFileDecodingStrategy) -> Bool {
    lhs.isEqual(to: rhs)
}

@_disfavoredOverload
public func != (lhs: any TextFileDecodingStrategy, rhs: any TextFileDecodingStrategy) -> Bool {
    !lhs.isEqual(to: rhs)
}
