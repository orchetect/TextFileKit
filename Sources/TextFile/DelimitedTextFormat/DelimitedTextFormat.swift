//
//  DelimitedTextFormat.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

/// Delimited text formats.
public enum DelimitedTextFormat {
    /// CSV (comma-separated values)
    case csv
    
    /// TSV (tab-separated values)
    case tsv
}

extension DelimitedTextFormat: Equatable { }

extension DelimitedTextFormat: Hashable { }

extension DelimitedTextFormat: CaseIterable { }

extension DelimitedTextFormat: Sendable { }

// MARK: - File Extension

extension DelimitedTextFormat {
    /// Returns the file extension used for the file format.
    public var fileExtension: String {
        switch self {
        case .csv: return "csv"
        case .tsv: return "tsv"
        }
    }
    
    /// Initialize from file extension.
    public init?(fileExtension: String) {
        guard let match = Self.allCases.first(where: { $0.fileExtension == fileExtension })
        else { return nil }
        
        self = match
    }
}
