//
//  NSStringTextFileDecodingStrategy.swift
//  swift-textfile
//
//  Created by Steffan Andrews on 2026-03-27.
//

#if canImport(Darwin)

import struct Foundation.Data
import protocol Foundation.DataProtocol
import class Foundation.FileManager
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
    
    public init(allowLossy: Bool = false, convertLineEndings: Bool = true) {
        self.allowLossy = allowLossy
        self.convertLineEndings = convertLineEndings
    }
}

extension NSStringTextFileDecodingStrategy: TextFileDecodingStrategy {
    public func decodeText(in data: Data) throws(TextFileDecodeError) -> DecodedTextFile {
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
        var decoded = DecodedTextFile(content: text, encoding: encoding, url: nil)
        if convertLineEndings { decoded.content = decoded.content.fixedLineBreaks }
        return decoded
    }
    
    public func decodeText(in data: Data, fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
        var decodedTextFile = try decodeText(in: data)
        decodedTextFile.url = fileURL
        return decodedTextFile
    }
    
    public func decodeText(fileURL: URL) throws(TextFileDecodeError) -> DecodedTextFile {
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            throw .fileReadError(underlyingError: error)
        }
        return try decodeText(in: data, fileURL: fileURL)
    }
}

// MARK: - Static Constructors

extension TextFileDecodingStrategy where Self == NSStringTextFileDecodingStrategy {
    /// NSString-based text file encoding detection.
    /// This method is only available on Apple platforms.
    public static func nsString(allowLossy: Bool = false, convertLineEndings: Bool = true) -> NSStringTextFileDecodingStrategy {
        NSStringTextFileDecodingStrategy(allowLossy: allowLossy, convertLineEndings: convertLineEndings)
    }
}

extension NSStringTextFileDecodingStrategy {
    var encodingOptions: [StringEncodingDetectionOptionsKey : Any]? {
        [.allowLossyKey: NSNumber(value: allowLossy)]
    }
}

#endif
