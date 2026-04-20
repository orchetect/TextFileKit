//
//  ByteOrderMark.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
#endif

// In UTF-16, a BOM (U+FEFF) may be placed as the first bytes of a file or character stream to indicate the
// endianness (byte order) of all the 16-bit code units of the file or stream. If an attempt is made to read this
// stream with the wrong endianness, the bytes will be swapped, thus delivering the character U+FFFE, which is
// defined by Unicode as a "noncharacter" that should never appear in the text.

// See: https://en.wikipedia.org/wiki/Byte_order_mark

/// Text encoding Byte Order Mark.
public enum ByteOrderMark {
    /// UTF-8 byte order.
    ///
    /// In UTF-8, there is no endianness (byte ordering). The BOM is used as a signature or identifier to text
    /// parsers to positively identify the text as having UTF-8 encoding.
    case utf8

    /// UTF-16 big-endian byte order. ("UTF-16 (BE)")
    case utf16BigEndian

    /// UTF-16 little-endian byte order. ("UTF-16 (LE)")
    case utf16LittleEndian

    /// UTF-32 big-endian byte order. ("UTF-32 (BE)")
    case utf32BigEndian

    /// UTF-32 little-endian byte order. ("UTF-32 (LE)")
    case utf32LittleEndian
}

extension ByteOrderMark: Equatable { }

extension ByteOrderMark: Hashable { }

extension ByteOrderMark: CaseIterable { }

extension ByteOrderMark: Sendable { }

extension ByteOrderMark: CustomStringConvertible {
    public var description: String {
        switch self {
        case .utf8: "UTF-8"
        case .utf16BigEndian: "UTF-16 (BE)"
        case .utf16LittleEndian: "UTF-16 (LE)"
        case .utf32BigEndian: "UTF-32 (BE)"
        case .utf32LittleEndian: "UTF-32 (LE)"
        }
    }
}

extension ByteOrderMark: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .utf8: "utf8"
        case .utf16BigEndian: "utf16BigEndian"
        case .utf16LittleEndian: "utf16LittleEndian"
        case .utf32BigEndian: "utf32BigEndian"
        case .utf32LittleEndian: "utf32LittleEndian"
        }
    }
}

// MARK: - Properties

extension ByteOrderMark {
    /// String containing the raw code points that correspond to the byte order mark.
    public var string: String {
        switch self {
        case .utf8: "\u{EF}\u{BB}\u{BF}"
        case .utf16BigEndian: "\u{FE}\u{FF}"
        case .utf16LittleEndian: "\u{FF}\u{FE}"
        case .utf32BigEndian: "\u{00}\u{00}\u{FE}\u{FF}"
        case .utf32LittleEndian: "\u{FF}\u{FE}\u{00}\u{00}"
        }
    }

    /// Byte array containing the raw code points that correspond to the byte order mark.
    public var bytes: [UInt8] {
        switch self {
        case .utf8: [0xEF, 0xBB, 0xBF]
        case .utf16BigEndian: [0xFE, 0xFF]
        case .utf16LittleEndian: [0xFF, 0xFE]
        case .utf32BigEndian: [0x00, 0x00, 0xFE, 0xFF]
        case .utf32LittleEndian: [0xFF, 0xFE, 0x00, 0x00]
        }
    }

    /// Data containing the raw code points that correspond to the byte order mark.
    public var data: Data {
        Data(bytes)
    }

    /// Returns the string encoding that corresponds to the byte order mark.
    public var encoding: String.Encoding {
        switch self {
        case .utf8: .utf8
        case .utf16BigEndian: .utf16BigEndian
        case .utf16LittleEndian: .utf16LittleEndian
        case .utf32BigEndian: .utf32BigEndian
        case .utf32LittleEndian: .utf32LittleEndian
        }
    }
}

// MARK: - Static

extension ByteOrderMark {
    /// The order with which to parse a text stream when matching byte order mark bytes.
    public static let parseOrder: [Self] = [
        .utf8,
        .utf32BigEndian,
        .utf32LittleEndian,
        .utf16BigEndian,
        .utf16LittleEndian
    ]
}
