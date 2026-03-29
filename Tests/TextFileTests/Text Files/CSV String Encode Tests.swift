//
//  CSV String Encode Tests.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.Bundle
import struct Foundation.Data
import Testing
import TestingExtensions
@testable import TextFile

struct CSV_StringEncode_Tests {
    private let csvTable_Basic: StringTable = [
        ["1", "2", "3"],
        ["á", "ç", "é"]
    ]
    
    @Test
    func data_utf8_withBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf8, includeBOM: true)
        
        let expectedBytes: [UInt8] = [
            0xEF, 0xBB, 0xBF, // UTF-8 BOM
            0x31, 0x2C, 0x32, 0x2C, 0x33, 0x0A, // "1,2,3" + newline
            0xC3, 0xA1, // á
            0x2C, // ,
            0xC3, 0xA7, // ç
            0x2C, // ,
            0xC3, 0xA9 // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf8_withoutBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf8, includeBOM: false)
        
        let expectedBytes: [UInt8] = [
            0x31, 0x2C, 0x32, 0x2C, 0x33, 0x0A, // "1,2,3" + newline
            0xC3, 0xA1, // á
            0x2C, // ,
            0xC3, 0xA7, // ç
            0x2C, // ,
            0xC3, 0xA9 // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf16BE_withBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf16BigEndian, includeBOM: true)
        
        let expectedBytes: [UInt8] = [
            0xFE, 0xFF, // UTF-16 big-endian BOM
            0x00, 0x31, // 1
            0x00, 0x2C, // ,
            0x00, 0x32, // 2
            0x00, 0x2C, // ,
            0x00, 0x33, // 3
            0x00, 0x0A, // newline
            0x00, 0xE1, // á
            0x00, 0x2C, // ,
            0x00, 0xE7, // ç
            0x00, 0x2C, // ,
            0x00, 0xE9  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf16BE_withoutBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf16BigEndian, includeBOM: false)
        
        let expectedBytes: [UInt8] = [
            0x00, 0x31, // 1
            0x00, 0x2C, // ,
            0x00, 0x32, // 2
            0x00, 0x2C, // ,
            0x00, 0x33, // 3
            0x00, 0x0A, // newline
            0x00, 0xE1, // á
            0x00, 0x2C, // ,
            0x00, 0xE7, // ç
            0x00, 0x2C, // ,
            0x00, 0xE9  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf16LE_withBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf16LittleEndian, includeBOM: true)
        
        let expectedBytes: [UInt8] = [
            0xFF, 0xFE, // UTF-16 little-endian BOM
            0x31, 0x00, // 1
            0x2C, 0x00, // ,
            0x32, 0x00, // 2
            0x2C, 0x00, // ,
            0x33, 0x00, // 3
            0x0A, 0x00, // newline
            0xE1, 0x00, // á
            0x2C, 0x00, // ,
            0xE7, 0x00, // ç
            0x2C, 0x00, // ,
            0xE9, 0x00  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf16LE_withoutBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf16LittleEndian, includeBOM: false)
        
        let expectedBytes: [UInt8] = [
            0x31, 0x00, // 1
            0x2C, 0x00, // ,
            0x32, 0x00, // 2
            0x2C, 0x00, // ,
            0x33, 0x00, // 3
            0x0A, 0x00, // newline
            0xE1, 0x00, // á
            0x2C, 0x00, // ,
            0xE7, 0x00, // ç
            0x2C, 0x00, // ,
            0xE9, 0x00  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf32BE_withBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf32BigEndian, includeBOM: true)
        
        let expectedBytes: [UInt8] = [
            0x00, 0x00, 0xFE, 0xFF, // UTF-32 big-endian BOM
            0x00, 0x00, 0x00, 0x31, // 1
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0x32, // 2
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0x33, // 3
            0x00, 0x00, 0x00, 0x0A, // newline
            0x00, 0x00, 0x00, 0xE1, // á
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0xE7, // ç
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0xE9  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf32BE_withoutBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf32BigEndian, includeBOM: false)
        
        let expectedBytes: [UInt8] = [
            0x00, 0x00, 0x00, 0x31, // 1
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0x32, // 2
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0x33, // 3
            0x00, 0x00, 0x00, 0x0A, // newline
            0x00, 0x00, 0x00, 0xE1, // á
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0xE7, // ç
            0x00, 0x00, 0x00, 0x2C, // ,
            0x00, 0x00, 0x00, 0xE9  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf32LE_withBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf32LittleEndian, includeBOM: true)
        
        let expectedBytes: [UInt8] = [
            0xFF, 0xFE, 0x00, 0x00, // UTF-32 little-endian BOM
            0x31, 0x00, 0x00, 0x00, // 1
            0x2C, 0x00, 0x00, 0x00, // ,
            0x32, 0x00, 0x00, 0x00, // 2
            0x2C, 0x00, 0x00, 0x00, // ,
            0x33, 0x00, 0x00, 0x00, // 3
            0x0A, 0x00, 0x00, 0x00, // newline
            0xE1, 0x00, 0x00, 0x00, // á
            0x2C, 0x00, 0x00, 0x00, // ,
            0xE7, 0x00, 0x00, 0x00, // ç
            0x2C, 0x00, 0x00, 0x00, // ,
            0xE9, 0x00, 0x00, 0x00  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test
    func data_utf32LE_withoutBOM() throws {
        let sv = CSV(table: csvTable_Basic)
        
        let data = try sv.data(encoding: .utf32LittleEndian, includeBOM: false)
        
        let expectedBytes: [UInt8] = [
            0x31, 0x00, 0x00, 0x00, // 1
            0x2C, 0x00, 0x00, 0x00, // ,
            0x32, 0x00, 0x00, 0x00, // 2
            0x2C, 0x00, 0x00, 0x00, // ,
            0x33, 0x00, 0x00, 0x00, // 3
            0x0A, 0x00, 0x00, 0x00, // newline
            0xE1, 0x00, 0x00, 0x00, // á
            0x2C, 0x00, 0x00, 0x00, // ,
            0xE7, 0x00, 0x00, 0x00, // ç
            0x2C, 0x00, 0x00, 0x00, // ,
            0xE9, 0x00, 0x00, 0x00  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test(arguments: [true, false])
    func data_windows1252_withBOM(includeBOM: Bool) throws {
        let sv = CSV(table: csvTable_Basic)
        
        // CP1252 has no BOM, so passing `true` has no effect
        let data = try sv.data(encoding: .windowsCP1252, includeBOM: includeBOM)
        
        let expectedBytes: [UInt8] = [
            0x31, 0x2C, 0x32, 0x2C, 0x33, 0x0A, // "1,2,3" + newline
            0xE1, // á
            0x2C, // ,
            0xE7, // ç
            0x2C, // ,
            0xE9  // é
        ]
        
        #expect([UInt8](data) == expectedBytes)
    }
    
    @Test(arguments: [true, false])
    func data_macRoman_withBOM(includeBOM: Bool) throws {
        let sv = CSV(table: csvTable_Basic)
        
        // MacRoman has no BOM, so passing `true` has no effect
        let data = try sv.data(encoding: .macOSRoman, includeBOM: includeBOM)
        
        let expectedBytes: [UInt8] = [
            0x31, 0x2C, 0x32, 0x2C, 0x33, 0x0A, // "1,2,3" + newline
            0x87, // á
            0x2C, // ,
            0x8D, // ç
            0x2C, // ,
            0x8E  // é
        ]
        
        #if canImport(Darwin)
        #expect([UInt8](data) == expectedBytes)
        #else
        withKnownIssue("MacRoman text decoding seems to not work correctly on Linux.") {
            #expect([UInt8](data) == expectedBytes)
        }
        #endif
    }
}
