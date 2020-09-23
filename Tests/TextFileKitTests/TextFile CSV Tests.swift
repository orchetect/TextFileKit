//  Created by Steffan Andrews on 2020-08-26.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

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

fileprivate let csvData_Basic = """
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
	
	func test_Init_RawData_Basic() {
		
		let sv = TextFile.CSV(rawData: csvData_Basic)
		
		XCTAssertEqual(sv.rawData, csvData_Basic)
		XCTAssertEqual(sv.table, csvTable_Basic)
		
	}
	
	func test_Init_Table_Basic() {
		
		let sv = TextFile.CSV(table: csvTable_Basic)
		
		XCTAssertEqual(sv.rawData, csvData_Basic)
		XCTAssertEqual(sv.table, csvTable_Basic)
		
	}
	
}


// MARK: - Single column

fileprivate let csvData_SingleColumn = """
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
	
	func test_Init_RawData_SingleColumn() {
		
		let sv = TextFile.CSV(rawData: csvData_SingleColumn)
		
		XCTAssertEqual(sv.rawData, csvData_SingleColumn)
		XCTAssertEqual(sv.table, csvTable_SingleColumn)
		
	}
	
	func test_Init_Table_SingleColumn() {
		
		let sv = TextFile.CSV(table: csvTable_SingleColumn)
		
		XCTAssertEqual(sv.rawData, csvData_SingleColumn)
		XCTAssertEqual(sv.table, csvTable_SingleColumn)
		
	}
	
}


// MARK: - Quoted fields

fileprivate let csvData_QuotedFields = #"""
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
	
	func test_Init_RawData_QuotedFields() {
		
		let sv = TextFile.CSV(rawData: csvData_QuotedFields)
		
		XCTAssertEqual(sv.rawData, csvData_QuotedFields)
		XCTAssertEqual(sv.table, csvTable_QuotedFields)
		
	}
	
}
