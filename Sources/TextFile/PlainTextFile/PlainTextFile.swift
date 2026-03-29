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
    public var content: String
    
    /// The source text file encoding.
    public var encoding: String.Encoding
    
    /// Initialize by directly populating properties without decoding or modification.
    public init(content: String, encoding: String.Encoding = .utf8) {
        self.content = content
        self.encoding = encoding
    }
}

extension PlainTextFile: Equatable { }

extension PlainTextFile: Hashable { }

extension PlainTextFile: Sendable { }
