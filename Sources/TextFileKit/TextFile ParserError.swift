//
//  TextFile ParserError.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TextFile {
    public enum ParserError: LocalizedError {
        case unrecognizedTextEncoding
        
        public var errorDescription: String? {
            switch self {
            case .unrecognizedTextEncoding:
                return "Unrecognized text encoding."
            }
        }
    }
}
