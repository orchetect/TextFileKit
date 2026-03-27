//
//  StringTableRepresentable.swift
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

/// Protocol describing file formats which can be encoded to/from a ``StringTable``.
public protocol StringTableRepresentable where Self: Sendable {
    /// Raw data store as an Array table addressed as `self[row][column]`. Subscripts are also available
    /// (`self[row, column]` or `self[safe: row, column]`) which allow the column to be specified either as
    /// an index (integer) or column name (string).
    var table: StringTable { get set }
    
    /// Raw text file content. (Computed property)
    ///
    /// This property is typically computed and is not guaranteed to be identical to raw file content that
    /// may have been used to initialize the instance.
    var rawText: String { get }
    
    /// Initialize from an Array table.
    init(table: StringTable)
    
    /// Initialize from raw text file content.
    ///
    /// > Note:
    /// >
    /// > When reading a text file that may contain a BOM (byte order mark) header it is recommended to use
    /// > the ``init(file:encoding:)`` or ``init(rawData:encoding:)`` initializers instead, which attempt
    /// > to detect text encoding.
    init(rawText: String)
}

extension StringTableRepresentable {
    /// Initialize from text file.
    ///
    /// - Parameters:
    ///   - file: File URL of path to file on disk.
    ///   - encoding: If the text encoding is known, it may be specified. Otherwise pass `nil` to attempt
    ///     automatic detection of text encoding.
    public init(file: URL, encoding: String.Encoding? = nil) throws(TextFileDecodeError) {
        let decoded = try DecodedTextFile(url: file, strategy: .default(), preferring: encoding)
        self.init(rawText: decoded.content)
    }
    
    /// Initialize from raw data with the specified text encoding.
    ///
    /// - Parameters:
    ///   - rawData: Raw text file data.
    ///   - encoding: If the text encoding is known, it may be specified. Otherwise pass `nil` to attempt
    ///     automatic detection of text encoding.
    ///
    /// - Note: On non-Apple platforms, if reading from a text file on disk, it is more efficient
    ///   to call ``init(file:encoding:)`` rather than read the contents of the file and supply it
    ///   to this method, as this method relies on rewriting the data to a file on disk in order to decode.
    public init(rawData: Data, encoding: String.Encoding? = nil) throws(TextFileDecodeError) {
        let decoded = try DecodedTextFile(data: rawData, strategy: .default(), preferring: encoding)
        self.init(rawText: decoded.content)
    }
}
