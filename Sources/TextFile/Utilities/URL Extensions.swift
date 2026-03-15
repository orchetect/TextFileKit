//
//  URL Extensions.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import class Foundation.FileManager
import struct Foundation.URL
#else
import class FoundationEssentials.FileManager
import struct FoundationEssentials.URL
#endif

extension URL {
    /// Backwards-compatible implementation of `temporaryDirectory`.
    static var temporaryDirectoryBackCompat: URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return .temporaryDirectory
        } else {
            return FileManager.default.temporaryDirectory
        }
    }
}
