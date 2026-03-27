//
//  CSV Encodings Tests.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import class Foundation.Bundle
import Testing
import TestingExtensions
@testable import TextFile

struct CSV_Encodings_Tests {
    // MARK: - MacRoman

    @Test func accentedCharacters_MacRoman_content() throws {
        let resource = TestResource.TextFiles.macRoman_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url, encoding: .macOSRoman) // TODO: can't auto-detect MacRoman, must specify it
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_MacRoman_rawText() throws {
        let resource = TestResource.TextFiles.macRoman_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url, encoding: .macOSRoman) // TODO: can't auto-detect MacRoman, must specify it

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .macOSRoman)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_MacRoman_encoding_string() throws {
        let resource = TestResource.TextFiles.macRoman_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(
                strategy: .string,
                encoding: .macOSRoman, // TODO: can't auto-detect MacRoman, must specify it
                file: url
            )
            #expect(encoding == .macOSRoman)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_MacRoman_encoding_nsString() throws {
        let resource = TestResource.TextFiles.macRoman_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(
                strategy: .nsString,
                encoding: .macOSRoman, // TODO: can't auto-detect MacRoman, must specify it
                file: url
            )
            #expect(encoding == .macOSRoman)
        }
    }
    #endif

    // MARK: - UTF-8

    @Test func accentedCharacters_utf8_content() throws {
        let resource = TestResource.TextFiles.utf8_AccentedCharacters_csv

        // parse CSV
        let url = try resource.url()
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf8_rawText() throws {
        let resource = TestResource.TextFiles.utf8_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .utf8)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_utf8_encoding_string() throws {
        let resource = TestResource.TextFiles.utf8_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf8)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf8_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf8_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf8)
        }
    }
    #endif

    // MARK: - UTF-8 with BOM

    @Test func accentedCharacters_utf8_BOM_content() throws {
        let resource = TestResource.TextFiles.utf8_BOM_AccentedCharacters_csv

        // parse CSV
        let url = try resource.url()
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf8_BOM_rawText() throws {
        let resource = TestResource.TextFiles.utf8_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = try #require(csv.rawText.data(using: .utf8))
        // BOM is not written to generated UTF-8 data
        #expect(csvData != resourceData)
        // data after BOM should still be identical
        let resourceDataPostBOMByteRange = resourceData.startIndex.advanced(by: ByteOrderMark.utf8.bytes.count)...
        #expect(csvData == resourceData[resourceDataPostBOMByteRange])
    }

    @Test func accentedCharacters_utf8_BOM_encoding_string() throws {
        let resource = TestResource.TextFiles.utf8_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf8)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf8_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf8_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf8)
        }
    }
    #endif

    // MARK: - UTF-16 Big-Endian

    @Test func accentedCharacters_utf16BE_content() throws {
        let resource = TestResource.TextFiles.utf16BE_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf16BE_rawText() throws {
        let resource = TestResource.TextFiles.utf16BE_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .utf16BigEndian)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_utf16BE_encoding_string() throws {
        let resource = TestResource.TextFiles.utf16BE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf16BigEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16BE_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16BE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf16BigEndian)
        }
    }
    #endif

    // MARK: - UTF-16 Big-Endian with BOM

    @Test func accentedCharacters_utf16BE_BOM_content() throws {
        let resource = TestResource.TextFiles.utf16BE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf16BE_BOM_rawText() throws {
        let resource = TestResource.TextFiles.utf16BE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .utf16BigEndian)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_utf16BE_BOM_encoding_string() throws {
        let resource = TestResource.TextFiles.utf16BE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf16BigEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16BE_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16BE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf16BigEndian)
        }
    }
    #endif

    // MARK: - UTF-16 Little-Endian

    @Test func accentedCharacters_utf16LE_content() throws {
        let resource = TestResource.TextFiles.utf16LE_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf16LE_rawText() throws {
        let resource = TestResource.TextFiles.utf16LE_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .utf16LittleEndian)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_utf16LE_encoding_string() throws {
        let resource = TestResource.TextFiles.utf16LE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf16LittleEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16LE_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16LE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf16LittleEndian)
        }
    }
    #endif

    // MARK: - UTF-16 Little-Endian with BOM

    @Test func accentedCharacters_utf16LE_BOM_content() throws {
        let resource = TestResource.TextFiles.utf16LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf16LE_BOM_rawText() throws {
        let resource = TestResource.TextFiles.utf16LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .utf16LittleEndian)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_utf16LE_BOM_encoding_string() throws {
        let resource = TestResource.TextFiles.utf16LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf16LittleEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16LE_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf16LittleEndian)
        }
    }
    #endif

    // MARK: - UTF-32 Little-Endian

    @Test func accentedCharacters_utf32LE_content() throws {
        let resource = TestResource.TextFiles.utf32LE_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf32LE_rawText() throws {
        let resource = TestResource.TextFiles.utf32LE_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .utf32LittleEndian)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_utf32LE_encoding_string() throws {
        let resource = TestResource.TextFiles.utf32LE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf32LittleEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf32LE_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf32LE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf32) // NSString reports utf32 since little-endian is platform default
        }
    }
    #endif

    // MARK: - UTF-32 Little-Endian with BOM

    @Test func accentedCharacters_utf32LE_BOM_content() throws {
        let resource = TestResource.TextFiles.utf32LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_utf32LE_BOM_rawText() throws {
        let resource = TestResource.TextFiles.utf32LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .utf32LittleEndian)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_utf32LE_BOM_encoding_string() throws {
        let resource = TestResource.TextFiles.utf32LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            #expect(encoding == .utf32LittleEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf32LE_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf32LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        do {
            let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
            #expect(encoding == .utf32LittleEndian)
        }
    }
    #endif

    // MARK: - Windows 1252

    @Test func accentedCharacters_windows1252_content() throws {
        let resource = TestResource.TextFiles.windows1252_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_windows1252_rawText() throws {
        let resource = TestResource.TextFiles.windows1252_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .windowsCP1252)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_windows1252_encoding_string() throws {
        let resource = TestResource.TextFiles.windows1252_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        withKnownIssue("String decoder doesn't recognized Windows 1252 encoding.") {
            let (_, encoding) = try data.decodeString(strategy: .string, file: url)
            _ = encoding // TODO: add support for Windows 1252 decoding on Linux
            // #expect(encoding == .windowsCP1252)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_windows1252_encoding_nsString() throws {
        let resource = TestResource.TextFiles.windows1252_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let data = try resource.data()
        let (_, encoding) = try data.decodeString(strategy: .nsString, file: url)
        #expect(encoding == .windowsCP1252)
    }
    #endif
}
