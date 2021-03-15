//
//  StringTable Tests.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2021-03-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TextFileKit

class StringTable_Tests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	func testRead() {
		
		let st: StringTable =
			[
				["1A", "1B"],
				["2A", "2B"],
				["3A", "3B"]
			]
		
		XCTAssertEqual(st[0][0], "1A")
		XCTAssertEqual(st[0][1], "1B")
		
		XCTAssertEqual(st[2][0], "3A")
		XCTAssertEqual(st[2][1], "3B")
		
	}
	
	func testWrite() {
		
		var st: StringTable =
			[
				["1A", "1B"],
				["2A", "2B"],
				["3A", "3B"]
			]
		
		// update
		
		XCTAssertEqual(st[1][0], "2A")
		
		st[1][0] = "2Anew"
		
		XCTAssertEqual(st[1][0], "2Anew")
		
		// append
		
		st.append(["4A", "4B"])
		
		XCTAssertEqual(st[3][0], "4A")
		XCTAssertEqual(st[3][1], "4B")
		
	}
	
	func testEquatable() {
		
		let st1: StringTable =
			[
				["1A", "1B"],
				["2A", "2B"],
				["3A", "3B"]
			]
		
		let st2: StringTable =
			[
				["1A", "1B"],
				["2A", "2B"],
				["3A", "3B"]
			]
		
		XCTAssertEqual(st1, st2)
		
	}
	
	func testNumberOfRowsColumns() {
		
		var st: StringTable
		
		st = []
		
		XCTAssertEqual(st.rowCount, 0)
		XCTAssertEqual(st.columnCount, 0)
		
		st = [["-", "-"]]
		
		XCTAssertEqual(st.rowCount, 1)
		XCTAssertEqual(st.columnCount, 2)
		
		st = [["-", "-", "-"],
			  ["-", "-", "-"]]
		
		XCTAssertEqual(st.rowCount, 2)
		XCTAssertEqual(st.columnCount, 3)
		
		// edge cases
		
		st = [["-"],
			  ["-", "-", "-"]]
		
		XCTAssertEqual(st.rowCount, 2)
		XCTAssertEqual(st.columnCount, 1)
		
	}
	
	func testSubscript() {
		
		var st: StringTable =
			[
				["1A", "1B"],
				["2A", "2B"],
				["3A", "3B"]
			]
		
		XCTAssertEqual(st[0, 0], "1A")
		XCTAssertEqual(st[0, 1], "1B")
		
		st[0, 1] = "1Bnew"
		XCTAssertEqual(st[0, 1], "1Bnew")
		
	}
	
	func testSafeSubscript() {
		
		var st: StringTable =
			[
				["1A", "1B"],
				["2A", "2B"],
				["3A"]
			]
		
		// existing
		
		XCTAssertEqual(st[safe: 0, 0], "1A")
		XCTAssertEqual(st[safe: 0, 1], "1B")
		
		st[safe: 0, 1] = "1Bnew"
		
		XCTAssertEqual(st[safe: 0, 1], "1Bnew")
		
		// non-existing
		
		XCTAssertEqual(st[safe: 2, 1], nil)
		
		st[safe: 0, 2] = "1C"
		XCTAssertEqual(st[safe: 0, 2], nil)
		
		st[safe: 3, 0] = "4A"
		XCTAssertEqual(st[safe: 3, 0], nil)
		
	}
	
}

#endif
