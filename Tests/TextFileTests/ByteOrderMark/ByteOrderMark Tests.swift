//
//  ByteOrderMark Tests.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import class Foundation.Bundle
import Testing
import TestingExtensions
@testable import TextFile

struct ByteOrderMark_Tests {
    /// Ensure `parseOrder` contains all cases.
    @Test
    func parseOrderMembers() {
        #expect(Set(ByteOrderMark.allCases) == Set(ByteOrderMark.parseOrder))
    }
    
    /// Does not test any functionality; simply reports the endianness of the current platform for diagnostics.
    @Test
    func currentPlatform_UTF16() throws {
        let string = "Test"
        let data = try #require(string.data(using: .utf16, allowLossyConversion: false))
        print([UInt8](data).map { String($0, radix: 16).uppercased() }.joined(separator: " "))
        
        let bom = try #require(data.byteOrderMarkPrefix)
        print("UTF-16 BOM: \(bom)")
    }
    
    /// Does not test any functionality; simply reports the endianness of the current platform for diagnostics.
    @Test
    func currentPlatform_UTF32() throws {
        let string = "Test"
        let data = try #require(string.data(using: .utf32, allowLossyConversion: false))
        print([UInt8](data).map { String($0, radix: 16).uppercased() }.joined(separator: " "))
        
        let bom = try #require(data.byteOrderMarkPrefix)
        print("UTF-32 BOM: \(bom)")
    }
}
