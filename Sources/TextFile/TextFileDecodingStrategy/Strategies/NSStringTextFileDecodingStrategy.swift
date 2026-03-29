//
//  NSStringTextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)

import Foundation
import struct Foundation.Data
import protocol Foundation.DataProtocol
import class Foundation.FileManager
import class Foundation.NSArray
import class Foundation.NSNumber
import class Foundation.NSString
import struct Foundation.StringEncodingDetectionOptionsKey
import struct Foundation.ObjCBool
import struct Foundation.URL
import struct Foundation.UUID

/// NSString-based text file encoding detection.
///
/// This method is only available on Apple platforms.
/// (`NSString.stringEncoding()` is not available on non-Apple platforms.)
public struct NSStringTextFileDecodingStrategy {
    public var convertLineEndings: Bool
    
    /// If `true`, allow lossy text decoding if decoding can't be detected automatically.
    public var allowLossy: Bool
    
    /// Preferred text encodings.
    public var suggestedEncodings: [String.Encoding]
    
    /// Disallowed text encodings.
    public var disallowedEncodings: [String.Encoding]
    
    public init(
        allowLossy: Bool = false,
        suggestedEncodings: [String.Encoding] = [],
        disallowedEncodings: [String.Encoding] = [],
        convertLineEndings: Bool = true
    ) {
        self.allowLossy = allowLossy
        self.suggestedEncodings = suggestedEncodings
        self.disallowedEncodings = disallowedEncodings
        self.convertLineEndings = convertLineEndings
    }
}

extension NSStringTextFileDecodingStrategy: Equatable { }

extension NSStringTextFileDecodingStrategy: Hashable { }

extension NSStringTextFileDecodingStrategy: Sendable { }

extension NSStringTextFileDecodingStrategy: TextFileDecodingStrategy {
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> PlainTextFile {
        var usedLossyConversion: ObjCBool = false // TODO: not used
        var nsString: NSString?
        guard case let rawValue = NSString.stringEncoding(
            for: data,
            encodingOptions: encodingOptions,
            convertedString: &nsString,
            usedLossyConversion: &usedLossyConversion
        ),
              rawValue != 0,
              let text = nsString as? String
        else {
            throw .unrecognizedTextEncoding
        }
        let encoding = String.Encoding(rawValue: rawValue)
        var decoded = PlainTextFile(content: text, encoding: encoding)
        if convertLineEndings { decoded.content = decoded.content.fixedLineBreaks }
        return decoded
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> PlainTextFile {
        try decodeText(in: data)
    }
    
    public func decodeText(fileURL: URL) throws(TextFileDecodeError) -> PlainTextFile {
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            throw .fileReadError(underlyingError: error)
        }
        return try decodeText(in: data, fileURL: fileURL)
    }
}

// MARK: - Utilities

extension NSStringTextFileDecodingStrategy {
    var encodingOptions: [StringEncodingDetectionOptionsKey: Any]? {
        var options: [StringEncodingDetectionOptionsKey: Any] = [:]
        
        options[.allowLossyKey] = NSNumber(value: allowLossy)
        
        if !suggestedEncodings.isEmpty {
            options[.suggestedEncodingsKey] = suggestedEncodings.asStringEncodingDetectionOptionsKeysNSArray
        }
        
        if !disallowedEncodings.isEmpty {
            options[.disallowedEncodingsKey] = disallowedEncodings.asStringEncodingDetectionOptionsKeysNSArray
        }
        
        return options
    }
}

extension Collection<String.Encoding> {
    /// Returns the collection as an NSArray of NSString encodings.
    var asStringEncodingDetectionOptionsKeysNSArray: NSArray {
        let keys: [UInt] = self.map(\.nsStringEncoding)
        return keys as NSArray
    }
}

extension String.Encoding {
    /// Returns the NSString encoding equivalent.
    @_disfavoredOverload
    public var nsStringEncoding: UInt /* a.k.a. NSStringEncoding */ {
        // AFAIK, we can just return rawValue and don't need the switch case
        
        switch self {
        case .ascii: return NSASCIIStringEncoding
        case .iso2022JP: return NSISO2022JPStringEncoding
        case .isoLatin1: return NSISOLatin1StringEncoding
        case .isoLatin2: return NSISOLatin2StringEncoding
        case .japaneseEUC: return NSJapaneseEUCStringEncoding
        case .macOSRoman: return NSMacOSRomanStringEncoding
        case .nextstep: return NSNEXTSTEPStringEncoding
        case .nonLossyASCII: return NSNonLossyASCIIStringEncoding
        case .shiftJIS: return NSShiftJISStringEncoding
        case .symbol: return NSSymbolStringEncoding
        case .unicode: return NSUnicodeStringEncoding
        case .utf8: return NSUTF8StringEncoding
        case .utf16: return NSUTF16StringEncoding
        case .utf16BigEndian: return NSUTF16BigEndianStringEncoding
        case .utf16LittleEndian: return NSUTF16LittleEndianStringEncoding
        case .utf32BigEndian: return NSUTF32BigEndianStringEncoding
        case .utf32LittleEndian: return NSUTF32LittleEndianStringEncoding
        case .windowsCP1250: return NSWindowsCP1250StringEncoding
        case .windowsCP1251: return NSWindowsCP1251StringEncoding
        case .windowsCP1252: return NSWindowsCP1252StringEncoding
        case .windowsCP1253: return NSWindowsCP1253StringEncoding
        case .windowsCP1254: return NSWindowsCP1254StringEncoding
        default: return rawValue
        }
    }
}

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == NSStringTextFileDecodingStrategy {
    /// NSString-based text file encoding detection.
    /// This method is only available on Apple platforms.
    public static func nsString(
        allowLossy: Bool = false,
        suggestedEncodings: [String.Encoding] = [],
        disallowedEncodings: [String.Encoding] = [],
        convertLineEndings: Bool = true
    ) -> NSStringTextFileDecodingStrategy {
        NSStringTextFileDecodingStrategy(
            allowLossy: allowLossy,
            suggestedEncodings: suggestedEncodings,
            disallowedEncodings: disallowedEncodings,
            convertLineEndings: convertLineEndings
        )
    }
}

#endif
