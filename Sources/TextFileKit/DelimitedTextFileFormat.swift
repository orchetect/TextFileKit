//
//  DelimitedTextFileFormat.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2024-09-22.
//

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

public enum DelimitedTextFileFormat: Equatable, Hashable, CaseIterable, Sendable {
    case csv
    case tsv
}

@available(macOS 11.0, *)
extension DelimitedTextFileFormat {
    /// Returns the UTI (Uniform Type Identifier) for the file format.
    public var utType: UTType {
        switch self {
        case .csv:
            return .commaSeparatedText
        case .tsv:
            return .tabSeparatedText
        }
    }
    
    /// Initialize from a UTI (Uniform Type Identifier).
    public init?(utType: UTType) {
        guard let match = Self.allCases.first(where: { $0.utType == utType })
        else { return nil }
        
        self = match
    }
}

extension DelimitedTextFileFormat {
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
