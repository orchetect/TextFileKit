//
//  TextFile CSV Tests.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2020-08-26.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TextFileKit

class CSV_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testInit() {
		
		let sv = TextFile.CSV()
		
		XCTAssertEqual(sv.table, [])
		
	}
	
}


// MARK: - Basic

fileprivate let csvRawText_Basic = """
header1,header2,header3
1,2,3
a,b,c
"""

fileprivate let csvTable_Basic: StringTable =
	[
		["header1", "header2", "header3"],
		["1","2","3"],
		["a","b","c"]
	]

extension CSV_Tests {
	
	func test_Init_RawText_Basic() {
		
		let sv = TextFile.CSV(rawText: csvRawText_Basic)
		
		XCTAssertEqual(sv.rawText, csvRawText_Basic)
		XCTAssertEqual(sv.table, csvTable_Basic)
		
	}
	
	func test_Init_Table_Basic() {
		
		let sv = TextFile.CSV(table: csvTable_Basic)
		
		XCTAssertEqual(sv.rawText, csvRawText_Basic)
		XCTAssertEqual(sv.table, csvTable_Basic)
		
	}
	
}


// MARK: - Single column

fileprivate let csvRawText_SingleColumn = """
header1
1
a
"""

fileprivate let csvTable_SingleColumn: StringTable =
	[
		["header1"],
		["1"],
		["a"]
	]

extension CSV_Tests {
	
	func test_Init_RawText_SingleColumn() {
		
		let sv = TextFile.CSV(rawText: csvRawText_SingleColumn)
		
		XCTAssertEqual(sv.rawText, csvRawText_SingleColumn)
		XCTAssertEqual(sv.table, csvTable_SingleColumn)
		
	}
	
	func test_Init_Table_SingleColumn() {
		
		let sv = TextFile.CSV(table: csvTable_SingleColumn)
		
		XCTAssertEqual(sv.rawText, csvRawText_SingleColumn)
		XCTAssertEqual(sv.table, csvTable_SingleColumn)
		
	}
	
}


// MARK: - Quoted fields

fileprivate let csvRawText_QuotedFields = #"""
header1,"header, 2",header3
1,2,"3 ""quoted"" here"
"one line
another line",b,c
q,w,"e
""quoted"", stuff"
"""#

fileprivate let csvTable_QuotedFields: StringTable =
	[
		["header1", "header, 2", "header3"],
		["1","2","3 \"quoted\" here"],
		["one line\nanother line","b","c"],
		["q", "w", "e\n\"quoted\", stuff"]
	]

extension CSV_Tests {
	
	func test_Init_RawText_QuotedFields() {
		
		let sv = TextFile.CSV(rawText: csvRawText_QuotedFields)
		
		XCTAssertEqual(sv.rawText, csvRawText_QuotedFields)
		XCTAssertEqual(sv.table, csvTable_QuotedFields)
		
	}
	
}

#endif
