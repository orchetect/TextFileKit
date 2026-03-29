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
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }

    @Test func accentedCharacters_MacRoman_rawText() throws {
        let resource = TestResource.TextFiles.macRoman_AccentedCharacters_csv
        let url = try resource.url()

        // parse CSV
        let csv = try CSV(file: url)

        // generate raw text
        let resourceData = try resource.data()
        let csvData = csv.rawText.data(using: .macOSRoman)
        #expect(csvData == resourceData)
    }

    @Test func accentedCharacters_MacRoman_encoding_string() throws {
        let resource = TestResource.TextFiles.macRoman_AccentedCharacters_csv
        let url = try resource.url()
        
        // check detected encoding
        let decoded = try DecodedTextFile(
            url: url,
            strategy: .string(),
            preferring: .macOSRoman // String API can't auto-detect MacRoman, must specify it
        )
        #expect(decoded.encoding == .macOSRoman)
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_MacRoman_encoding_nsString() throws {
        let resource = TestResource.TextFiles.macRoman_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let decoded = try DecodedTextFile(
            url: url,
            strategy: .nsString(),
            preferring: .macOSRoman // NSString API can't auto-detect MacRoman, must specify it
        )
        #expect(decoded.encoding == .macOSRoman)
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
        let decoded = try DecodedTextFile(url: url, strategy: .string())
        #expect(decoded.encoding == .utf8)
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf8_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf8_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let decoded = try DecodedTextFile(url: url, strategy: .nsString())
        #expect(decoded.encoding == .utf8)
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
        let decoded = try DecodedTextFile(url: url, strategy: .string())
        #expect(decoded.encoding == .utf8)
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf8_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf8_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let decoded = try DecodedTextFile(url: url, strategy: .nsString())
        #expect(decoded.encoding == .utf8)
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
        withKnownIssue("String decoding API cannot auto-detect UTF-16 without a BOM.") {
            let decoded = try DecodedTextFile(url: url, strategy: .string())
            _ = decoded
            // #expect(decoded.encoding == .utf16BigEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16BE_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16BE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        withKnownIssue("NSString decoding API cannot auto-detect UTF-16 without a BOM.") {
            let decoded = try DecodedTextFile(url: url, strategy: .nsString())
             _ = decoded
            // #expect(decoded.encoding == .utf16BigEndian)
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
        let decoded = try DecodedTextFile(url: url, strategy: .string())
        #expect((decoded.encoding == .utf16BigEndian) || (decoded.encoding == .utf16))
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16BE_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16BE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let decoded = try DecodedTextFile(url: url, strategy: .nsString())
        #expect((decoded.encoding == .utf16BigEndian) || (decoded.encoding == .utf16))
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
        withKnownIssue("String decoding API cannot auto-detect UTF-16 without a BOM.") {
            let decoded = try DecodedTextFile(url: url, strategy: .string())
            _ = decoded
            // #expect(decoded.encoding == .utf16LittleEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16LE_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16LE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        withKnownIssue("NSString decoding API cannot auto-detect UTF-16 without a BOM.") {
            let decoded = try DecodedTextFile(url: url, strategy: .nsString())
            _ = decoded
            // #expect(decoded.encoding == .utf16LittleEndian)
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
        let decoded = try DecodedTextFile(url: url, strategy: .string())
        #expect((decoded.encoding == .utf16LittleEndian) || (decoded.encoding == .utf16))
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf16LE_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf16LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let decoded = try DecodedTextFile(url: url, strategy: .nsString())
        #expect((decoded.encoding == .utf16LittleEndian) || (decoded.encoding == .utf16))
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
        withKnownIssue("String decoding API cannot auto-detect UTF-32 without a BOM.") {
            let decoded = try DecodedTextFile(url: url, strategy: .string())
            _ = decoded
            // #expect(decoded.encoding == .utf32LittleEndian)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf32LE_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf32LE_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        withKnownIssue("NSString decoding API cannot auto-detect UTF-32 without a BOM.") {
            let decoded = try DecodedTextFile(url: url, strategy: .nsString())
            _ = decoded
            // #expect(decoded.encoding == .utf32LittleEndian)
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
        let decoded = try DecodedTextFile(url: url, strategy: .string())
        #expect((decoded.encoding == .utf32LittleEndian) || (decoded.encoding == .utf32))
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_utf32LE_BOM_encoding_nsString() throws {
        let resource = TestResource.TextFiles.utf32LE_BOM_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let decoded = try DecodedTextFile(url: url, strategy: .nsString())
        #expect((decoded.encoding == .utf32LittleEndian) || (decoded.encoding == .utf32))
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
        // TODO: add support for Windows 1252 decoding on Linux
        withKnownIssue("String decoding API doesn't recognize Windows 1252 encoding.") {
            let decoded = try DecodedTextFile(url: url, strategy: .string())
            _ = decoded
            // #expect(decoded.encoding == .windowsCP1252)
        }
    }

    #if canImport(Darwin)
    @Test func accentedCharacters_windows1252_encoding_nsString() throws {
        let resource = TestResource.TextFiles.windows1252_AccentedCharacters_csv
        let url = try resource.url()

        // check detected encoding
        let decoded = try DecodedTextFile(url: url, strategy: .nsString())
        #expect(decoded.encoding == .windowsCP1252)
    }
    #endif
    
    // MARK: - Windows 1252 with UTF-8 BOM (Malformed)
    
    /// This tests a scenario of a CSV file found in the wild that was malformed.
    /// The file was Windows 1252 encoded, but had a UTF-8 BOM errantly inserted at the start.
    @Test func accentedCharacters_windows1252_utf8BOM_content() throws {
        let resource = TestResource.TextFiles.windows1252_AccentedCharacters_WithUTF8BOM_csv
        let url = try resource.url()
        
        // parse CSV
        let csv = try CSV(file: url)
        #expect(csv.table[safeRow: 1, col: 0] == "Cliché")
        #expect(csv.table[safeRow: 1, col: 1] == "Français")
        #expect(csv.table[safeRow: 2, col: 0] == "Frères")
        #expect(csv.table[safeRow: 2, col: 1] == "Piñata")
    }
}
