//
//  TextFileEncodeError.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import protocol Foundation.LocalizedError

public enum TextFileEncodeError: LocalizedError {
    case encodingFailed(underlyingError: Error?)
    case fileWriteError(underlyingError: Error?)
    
    public var errorDescription: String? {
        switch self {
        case let .encodingFailed(underlyingError):
            var string = "Failed to encode text: "
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
        }
    }
}
