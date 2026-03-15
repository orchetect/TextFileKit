//
//  StringTableRepresentable.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import struct Foundation.URL
#else
import struct FoundationEssentials.Data
import struct FoundationEssentials.URL
#endif

/// Protocol describing file formats which can be encoded to/from a ``StringTable``
/// (String Array table of rows and columns).
public protocol StringTableRepresentable where Self: Sendable {
    /// Raw data store as an Array table addressed as `self[row][column]`,
    /// `self[row, column]` or `self[safe: row, column]`.
    var table: StringTable { get set }
    
    /// (Computed property) Raw text content of the file.
    ///
    /// This property is typically computed and is not guaranteed to be identical to raw file content that may have been
    /// used to initialize the instance.
    var rawText: String { get }
    
    /// Initialize from an Array table addressed as `self[row][column]`,
    /// `self[row, column]` or `self[safe: row, column]`.
    init(table: StringTable)
    
    /// Initialize from raw text.
    ///
    /// > Note:
    /// >
    /// > When reading a text file that may contain a BOM (byte order mark) header it is recommended to use the
    /// > ``init(file:)`` or ``init(rawData:)`` initializers instead, which can detect text encoding.
    init(rawText: String)
}

extension StringTableRepresentable {
    /// Initialize from text file.
    public init(file: URL) throws {
        let rawData = try Data(contentsOf: file)
        
        var (text, encoding) = try rawData.decodeString(file: file)
        _ = encoding // not using encoding after successful string decode
        
        text = text.fixedLineBreaks
        
        self.init(rawText: text)
    }
    
    /// Initialize from raw data with the specified text encoding.
    public init(rawData: Data, encoding: String.Encoding) throws(TextFile.ParserError) {
        guard var text = String(data: rawData, encoding: encoding) else {
            throw .invalidTextEncoding
        }
        
        text = text.fixedLineBreaks
        
        self.init(rawText: text)
    }
            
    /// Initialize from raw data, auto-detecting text encoding.
    ///
    /// - Note: On non-Apple platforms, if reading from a text file on disk, it is more efficient
    ///   to call ``init(file:)`` rather than read the contents of the file and supply it to this method,
    ///   as this method relies on rewriting the data to a file on disk in order to decode.
    public init(rawData: Data) throws {
        var (text, encoding) = try rawData.decodeString()
        _ = encoding // not using encoding after successful string decode
        
        text = text.fixedLineBreaks
        
        self.init(rawText: text)
    }
}
