//
//  PlainTextFile+Encode.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import Foundation
#else
import FoundationEssentials
#endif

// MARK: - Data

extension PlainTextFile {
    /// Returns the text encoded into data using the assigned ``encoding``.
    ///
    /// - Parameters:
    ///   - includeBOM: When `true`, if the text encoding carries a byte order mark (BOM), it will be inserted at
    ///     the head of the file. For UTF-8 it is not always necessary, but some applications such as Excel will
    ///     not correctly identify the text encoding without it. For UTF-16 and UTF-32 it is highly recommended.
    public func data(includeBOM: Bool = true) throws(TextFileEncodeError) -> Data {
        guard var data = content.data(using: encoding) else {
            throw .encodingFailed(underlyingError: nil)
        }

        if let bom = encoding.byteOrderMark {
            if includeBOM {
                if !data.starts(with: bom.data) {
                    // add only if BOM is not present
                    data.insert(contentsOf: bom.data, at: 0)
                }
            } else {
                // remove BOM if present
                if data.starts(with: bom.data) {
                    data.removeFirst(bom.data.count)
                }
            }
        }

        return data
    }
}

// MARK: - Write

extension PlainTextFile {
    /// Write the text to a file on disk using the assigned ``encoding``.
    ///
    /// - Parameters:
    ///   - file: Output file URL.
    ///   - includeBOM: When `true`, if the text encoding carries a byte order mark (BOM), it will be inserted at
    ///     the head of the file. For UTF-8 it is not always necessary, but some applications such as Excel will
    ///     not correctly identify the text encoding without it. For UTF-16 and UTF-32 it is highly recommended.
    public func write(to file: URL, includeBOM: Bool = true) throws(TextFileEncodeError) {
        let data = try data(includeBOM: includeBOM)

        do {
            try data.write(to: file)
        } catch {
            throw .encodingFailed(underlyingError: error)
        }
    }
}
