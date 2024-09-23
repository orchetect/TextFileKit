//
//  TextFile TSV Tests.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TextFileKit
import XCTest

final class TSV_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit() {
        let sv = TextFile.TSV()
        
        XCTAssertEqual(sv.table, [])
    }
}

// MARK: - Basic

private let tsvRawText_Basic = """
    header1	header2	header3
    1	2	3
    a	b	c
    """

private let tsvTable_Basic: StringTable = [
    ["header1", "header2", "header3"],
    ["1", "2", "3"],
    ["a", "b", "c"]
]

extension TSV_Tests {
    func test_Init_RawText_Basic() {
        let sv = TextFile.TSV(rawText: tsvRawText_Basic)
        
        XCTAssertEqual(sv.table, tsvTable_Basic)
        XCTAssertEqual(sv.rawText, tsvRawText_Basic)
    }
    
    func test_Init_Table_Basic() {
        let sv = TextFile.TSV(table: tsvTable_Basic)
        
        XCTAssertEqual(sv.table, tsvTable_Basic)
        XCTAssertEqual(sv.rawText, tsvRawText_Basic)
    }
}

// MARK: - Single column

private let tsvRawText_SingleColumn = """
    header1
    1
    a
    """

private let tsvTable_SingleColumn: StringTable = [
    ["header1"],
    ["1"],
    ["a"]
]

extension TSV_Tests {
    func test_Init_RawText_SingleColumn() {
        let sv = TextFile.TSV(rawText: tsvRawText_SingleColumn)
        
        XCTAssertEqual(sv.table, tsvTable_SingleColumn)
        XCTAssertEqual(sv.rawText, tsvRawText_SingleColumn)
    }
    
    func test_Init_Table_SingleColumn() {
        let sv = TextFile.TSV(table: tsvTable_SingleColumn)
        
        XCTAssertEqual(sv.table, tsvTable_SingleColumn)
        XCTAssertEqual(sv.rawText, tsvRawText_SingleColumn)
    }
}

// MARK: - Quoted fields

private let tsvRawText_QuotedFields = #"""
header1	"header	2"	header3
1	2	3 "quoted" here
"one line
another line"	b	c
q	w	"e
""quoted""	stuff"
"""#

private let tsvTable_QuotedFields: StringTable = [
    ["header1", "header\t2", "header3"],
    ["1", "2", "3 \"quoted\" here"],
    ["one line\nanother line", "b", "c"],
    ["q", "w", "e\n\"quoted\"\tstuff"]
]

extension TSV_Tests {
    func test_Init_RawText_QuotedFields() {
        let sv = TextFile.TSV(rawText: tsvRawText_QuotedFields)
        
        XCTAssertEqual(sv.table, tsvTable_QuotedFields)
        XCTAssertEqual(sv.rawText, tsvRawText_QuotedFields)
    }
}
