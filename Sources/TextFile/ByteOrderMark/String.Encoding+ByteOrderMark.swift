//
//  String.Encoding+ByteOrderMark.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import Foundation
#else
import Foundation
#endif

extension String.Encoding {
    /// Returns the encoding's byte order mark, if applicable.
    public var byteOrderMark: ByteOrderMark? {
        switch self {
        case .utf8: .utf8
        case .utf16BigEndian: .utf16BigEndian
        case .utf16LittleEndian: .utf16LittleEndian
        case .utf32BigEndian: .utf32BigEndian
        case .utf32LittleEndian: .utf32LittleEndian
        default: nil
        }
    }
}
