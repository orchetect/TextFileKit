//
//  Data Extensions.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import class Foundation.FileManager
import class Foundation.NSString
import struct Foundation.ObjCBool
import struct Foundation.URL
import struct Foundation.UUID
#else
import class Foundation.NSString
import struct Foundation.ObjCBool
import struct FoundationEssentials.Data
import class FoundationEssentials.FileManager
import struct FoundationEssentials.URL
import struct FoundationEssentials.UUID
#endif

extension Data {
    /// Attempts to decode raw text file content.
    /// 
    /// - Parameters:
    ///   - file: This parameter is only used on non-Apple platforms.
    ///     If the data was read from a file on disk, supply the file URL.
    ///     If use of the file is required, it will be read if the file exists on disk.
    ///     Otherwise, a temporary file will be created in the system temporary folder.
    ///
    /// - Returns: The decoded string and string encoding if successful.
    func decodeString(file: URL? = nil) throws(TextFileDecodeError) -> (string: String, encoding: String.Encoding) {
        var text: String
        var encoding: String.Encoding
        
        #if canImport(Darwin)
        // Apple platforms
        // (`NSString.stringEncoding()` is not available on non-Apple platforms)
        
        var usedLossyConversion: ObjCBool = false // TODO: not used
        var nsString: NSString?
        guard case let rawValue = NSString.stringEncoding(
            for: self,
            encodingOptions: nil,
            convertedString: &nsString,
            usedLossyConversion: &usedLossyConversion
        ),
            rawValue != 0,
            let rawText = nsString as? String
        else {
            throw .unrecognizedTextEncoding
        }
        encoding = String.Encoding(rawValue: rawValue)
        text = rawText
        #else
        // non-Apple platforms
        
        let textFileURL: URL
        var isDirectory = ObjCBool(false)
        if let file,
            FileManager.default.fileExists(atPath: file.path, isDirectory: &isDirectory),
            !isDirectory.boolValue
        {
            // use the supplied file path if it exists
            textFileURL = file
        } else {
            // write out to a file on disk, as this String API requires reading from a file
            textFileURL = .temporaryDirectoryBackCompat
                .appendingPathComponent("\(UUID().uuidString).txt")
            do {
                try self.write(to: textFileURL)
            } catch {
                throw .fileWriteError(underlyingError: error)
            }
        }
        
        do {
            var usedEncoding: String.Encoding = .utf8
            text = try String(contentsOfFile: textFileURL.path, usedEncoding: &usedEncoding)
            encoding = usedEncoding
        } catch {
            throw .fileWriteError(underlyingError: error)
        }
        #endif
        
        return (string: text, encoding: encoding)
    }
}
