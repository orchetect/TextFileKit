//
//  TextFile DelimitedFormat.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

extension TextFile {
    public enum DelimitedFormat: Equatable, Hashable, CaseIterable, Sendable {
        case csv
        case tsv
    }
}

extension TextFile.DelimitedFormat {
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
