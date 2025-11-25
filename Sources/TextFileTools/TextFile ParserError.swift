//
//  TextFile ParserError.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
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
