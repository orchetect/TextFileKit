//
//  TextFile DelimitedFormat+UTType.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(UniformTypeIdentifiers)

import UniformTypeIdentifiers

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

#endif
