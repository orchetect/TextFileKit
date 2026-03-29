//
//  TSV.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

// tested with Google Sheets, Microsoft Excel, and Apple Numbers

/// TSV (Tab-Separated Values) text file format.
public struct TSV: StringTableRepresentable {
    // MARK: - Constants

    static let sepChar: Character = "\t"
    static let newLineChar: Character = "\n"

    public static let fileExtension = "tsv"

    // MARK: - Variables

    public var table: StringTable = []

    // MARK: - Init

    public init(table: StringTable = []) {
        self.table = table
    }

    public init(text: String) {
        table = Self.parse(text: text)
    }
}

extension TSV: Equatable { }

extension TSV: Hashable { }

extension TSV: Sendable { }
