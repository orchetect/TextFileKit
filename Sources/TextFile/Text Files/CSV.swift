//
//  CSV.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

// CSV format: https://en.wikipedia.org/wiki/Comma-separated_values

// tested with Google Sheets, Microsoft Excel, and Apple Numbers

/// CSV (Comma-Separated Values) text file format.
public struct CSV: StringTableRepresentable {
    // MARK: - Constants

    static let sepChar: Character = ","
    static let newLineChar: Character = "\n"

    public static let fileExtension = "csv"

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

extension CSV: Equatable { }

extension CSV: Hashable { }

extension CSV: Sendable { }
