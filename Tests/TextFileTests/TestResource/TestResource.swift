//
//  TestResource.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import class Foundation.Bundle
import Testing
import TestingExtensions

// NOTE: DO NOT name any folders "Resources". Xcode will fail to build iOS targets.

/// Resources files on disk used for unit testing.
extension TestResource {
    enum TextFiles {
        // MARK: - Basic UTF-8 BOM Samples
        
        static let utf8_BOM_Test_csv = TestResource.File(
            name: "utf8-bom-test", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf8_BOM_CRLF_Test_csv = TestResource.File(
            name: "utf8-bom-crlf-test", ext: "csv", subFolder: "Text Files"
        )
        
        // MARK: - Accented Characters
        
        static let macRoman_AccentedCharacters_csv = TestResource.File(
            name: "macroman-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf8_AccentedCharacters_csv = TestResource.File(
            name: "utf8-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf8_BOM_AccentedCharacters_csv = TestResource.File(
            name: "utf8-bom-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf16BE_AccentedCharacters_csv = TestResource.File(
            name: "utf16be-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf16BE_BOM_AccentedCharacters_csv = TestResource.File(
            name: "utf16be-bom-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf16LE_AccentedCharacters_csv = TestResource.File(
            name: "utf16le-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf16LE_BOM_AccentedCharacters_csv = TestResource.File(
            name: "utf16le-bom-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf32BE_AccentedCharacters_csv = TestResource.File(
            name: "utf32be-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf32BE_BOM_AccentedCharacters_csv = TestResource.File(
            name: "utf32be-bom-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf32LE_AccentedCharacters_csv = TestResource.File(
            name: "utf32le-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf32LE_BOM_AccentedCharacters_csv = TestResource.File(
            name: "utf32le-bom-accented-characters", ext: "csv", subFolder: "Text Files"
        )
        
        static let windows1252_AccentedCharacters_csv = TestResource.File(
            name: "windows1252-accented-characters", ext: "csv", subFolder: "Text Files"
        )
    }
}
