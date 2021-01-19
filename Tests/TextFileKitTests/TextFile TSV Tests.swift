//
//  TextFile TSV Tests.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2020-08-26.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TextFileKit

class TSV_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testInit() {
		
		let sv = TextFile.TSV()
		
		XCTAssertEqual(sv.table, [])
		
	}
	
}


// MARK: - Basic

fileprivate let tsvData_Basic = """
header1	header2	header3
1	2	3
a	b	c
"""

fileprivate let tsvTable_Basic: StringTable =
	[
		["header1", "header2", "header3"],
		["1","2","3"],
		["a","b","c"]
	]

extension TSV_Tests {

	func test_Init_RawData_Basic() {
		
		let sv = TextFile.TSV(rawData: tsvData_Basic)
		
		XCTAssertEqual(sv.rawData, tsvData_Basic)
		XCTAssertEqual(sv.table, tsvTable_Basic)
		
	}
	
	func test_Init_Table_Basic() {
		
		let sv = TextFile.TSV(table: tsvTable_Basic)
		
		XCTAssertEqual(sv.rawData, tsvData_Basic)
		XCTAssertEqual(sv.table, tsvTable_Basic)
		
	}
	
}


// MARK: - Single column

fileprivate let tsvData_SingleColumn = """
header1
1
a
"""

fileprivate let tsvTable_SingleColumn: StringTable =
	[
		["header1"],
		["1"],
		["a"]
	]

extension TSV_Tests {
	
	func test_Init_RawData_SingleColumn() {
		
		let sv = TextFile.TSV(rawData: tsvData_SingleColumn)
		
		XCTAssertEqual(sv.rawData, tsvData_SingleColumn)
		XCTAssertEqual(sv.table, tsvTable_SingleColumn)
		
	}
	
	func test_Init_Table_SingleColumn() {
		
		let sv = TextFile.TSV(table: tsvTable_SingleColumn)
		
		XCTAssertEqual(sv.rawData, tsvData_SingleColumn)
		XCTAssertEqual(sv.table, tsvTable_SingleColumn)
		
	}
	
}


// MARK: - Quoted fields

fileprivate let tsvData_QuotedFields = #"""
header1	"header	2"	header3
1	2	3 "quoted" here
"one line
another line"	b	c
q	w	"e
""quoted""	stuff"
"""#

fileprivate let tsvTable_QuotedFields: StringTable =
	[
		["header1", "header\t2", "header3"],
		["1","2","3 \"quoted\" here"],
		["one line\nanother line","b","c"],
		["q", "w", "e\n\"quoted\"\tstuff"]
	]

extension TSV_Tests {
	
	func test_Init_RawData_QuotedFields() {
		
		let sv = TextFile.TSV(rawData: tsvData_QuotedFields)
		
		XCTAssertEqual(sv.rawData, tsvData_QuotedFields)
		XCTAssertEqual(sv.table, tsvTable_QuotedFields)
		
	}
	
}

#endif
