//
//  StringTableRepresentable.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
        try self.init(rawData: rawData)
    }
    
    /// Initialize from raw data.
    public init(rawData: Data) throws {
        var usedLossyConversion: ObjCBool = false // TODO: not used
        var nsString: NSString?
        guard case let rawValue = NSString.stringEncoding(
            for: rawData,
            encodingOptions: nil,
            convertedString: &nsString,
            usedLossyConversion: &usedLossyConversion
        ),
              rawValue != 0,
              let rawText = nsString as? String
        else {
            throw TextFile.ParserError.unrecognizedTextEncoding
        }
        let /*encoding*/ _ = String.Encoding(rawValue: rawValue) // TODO: not used
        
        self.init(rawText: rawText)
    }
}
