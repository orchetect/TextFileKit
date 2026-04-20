//
//  URL Extensions.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import class Foundation.FileManager
import struct Foundation.ObjCBool
import struct Foundation.URL
#else
import struct Foundation.ObjCBool
import class FoundationEssentials.FileManager
import struct FoundationEssentials.URL
#endif

extension URL {
    /// Backwards-compatible implementation of `temporaryDirectory`.
    static var temporaryDirectoryBackCompat: URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            .temporaryDirectory
        } else {
            FileManager.default.temporaryDirectory
        }
    }

    /// Returns file existence and directory information if the URL is a file URL.
    /// If the URL is not a file URL, `nil` is returned
    var fileURLStatus: (isExists: Bool, isDirectory: Bool)? {
        guard isFileURL else { return nil }

        var isDirectory = ObjCBool(false)
        let isExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return (isExists: isExists, isDirectory: isDirectory.boolValue)
    }
}
