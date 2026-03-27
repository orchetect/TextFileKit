//
//  TextFile ParserError.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import protocol Foundation.LocalizedError

public enum TextFileDecodeError: LocalizedError {
    case fileReadError(underlyingError: Error?)
    case fileWriteError(underlyingError: Error?)
    case invalidTextEncoding
    case unrecognizedTextEncoding
    
    public var errorDescription: String? {
        switch self {
        case let .fileReadError(underlyingError):
            var string = "File read error"
            if let underlyingError {
                string += ": \(underlyingError.localizedDescription)"
            } else {
                string += "."
            }
            return string
            
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
