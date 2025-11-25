//
//  TextFile DelimitedFormat.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

extension TextFile {
    public enum DelimitedFormat: Equatable, Hashable, CaseIterable, Sendable {
        case csv
        case tsv
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension TextFile.DelimitedFormat {
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
