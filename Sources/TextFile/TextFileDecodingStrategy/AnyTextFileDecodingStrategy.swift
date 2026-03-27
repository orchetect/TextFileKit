//
//  AnyTextFileDecodingStrategy.swift
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

/// Type-erased box containing a specialized ``TextFileDecodingStrategy`` instance.
public struct AnyTextFileDecodingStrategy {
    public var wrapped: any TextFileDecodingStrategy
    
    public init(_ wrapped: any TextFileDecodingStrategy) {
        self.wrapped = wrapped
    }
}

extension AnyTextFileDecodingStrategy: Sendable { }

extension AnyTextFileDecodingStrategy: TextFileDecodingStrategy {
    public var convertLineEndings: Bool {
        get { wrapped.convertLineEndings }
        set { wrapped.convertLineEndings = newValue }
    }
    
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> DecodedTextFile {
        try wrapped.decodeText(in: data)
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
        try wrapped.decodeText(in: data, fileURL: fileURL)
    }
    
    public func decodeText(fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
        try wrapped.decodeText(fileURL: fileURL)
    }
}

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == AnyTextFileDecodingStrategy {
    /// Returns the best text file decoding method for the current platform.
    public static func `default`() -> AnyTextFileDecodingStrategy {
        AnyTextFileDecodingStrategy(.hybrid())
    }
}
