//
//  NSStringTextFileDecodingStrategy.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)

import Foundation
import struct Foundation.Data
import protocol Foundation.DataProtocol
import class Foundation.FileManager
import class Foundation.NSArray
import class Foundation.NSNumber
import class Foundation.NSString
import struct Foundation.ObjCBool
import struct Foundation.StringEncodingDetectionOptionsKey
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
        let keys: [UInt] = map(\.nsStringEncoding)
        return keys as NSArray
    }
}

extension String.Encoding {
    /// Returns the NSString encoding equivalent.
    @_disfavoredOverload
    public var nsStringEncoding: UInt /* a.k.a. NSStringEncoding */ {
        // AFAIK, we can just return rawValue and don't need the switch case
        
        switch self {
        case .ascii: NSASCIIStringEncoding
        case .iso2022JP: NSISO2022JPStringEncoding
        case .isoLatin1: NSISOLatin1StringEncoding
        case .isoLatin2: NSISOLatin2StringEncoding
        case .japaneseEUC: NSJapaneseEUCStringEncoding
        case .macOSRoman: NSMacOSRomanStringEncoding
        case .nextstep: NSNEXTSTEPStringEncoding
        case .nonLossyASCII: NSNonLossyASCIIStringEncoding
        case .shiftJIS: NSShiftJISStringEncoding
        case .symbol: NSSymbolStringEncoding
        case .unicode: NSUnicodeStringEncoding
        case .utf8: NSUTF8StringEncoding
        case .utf16: NSUTF16StringEncoding
        case .utf16BigEndian: NSUTF16BigEndianStringEncoding
        case .utf16LittleEndian: NSUTF16LittleEndianStringEncoding
        case .utf32BigEndian: NSUTF32BigEndianStringEncoding
        case .utf32LittleEndian: NSUTF32LittleEndianStringEncoding
        case .windowsCP1250: NSWindowsCP1250StringEncoding
        case .windowsCP1251: NSWindowsCP1251StringEncoding
        case .windowsCP1252: NSWindowsCP1252StringEncoding
        case .windowsCP1253: NSWindowsCP1253StringEncoding
        case .windowsCP1254: NSWindowsCP1254StringEncoding
        default: rawValue
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
