//
//  TextFile ParserError.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import protocol Foundation.LocalizedError

extension TextFile {
    public enum ParserError: LocalizedError {
        case fileWriteError(underlyingError: Error?)
        case invalidTextEncoding
        case unrecognizedTextEncoding
        
        public var errorDescription: String? {
            switch self {
            case let .fileWriteError(underlyingError):
                var string = "File write error"
                if let underlyingError {
                    string += ": \(underlyingError.localizedDescription)"
                } else {
                    string += "."
                }
                return string
                
            case .invalidTextEncoding:
                return "Invalid text encoding."
                
            case .unrecognizedTextEncoding:
                return "Unrecognized text encoding."
            }
        }
    }
}
