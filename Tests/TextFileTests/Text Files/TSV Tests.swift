//
//  TSV Tests.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import Testing
@testable import TextFile

@Suite struct TSV_Tests {
    @Test func init_Default() {
        let sv = TSV()
        
        #expect(sv.table == [])
    }
}

// MARK: - Basic

@Suite struct TSV_Basic_Tests {
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
    
    @Test func init_RawText_Basic() {
        let sv = TSV(text: tsvRawText_Basic)
        
        #expect(sv.table == tsvTable_Basic)
        #expect(sv.text == tsvRawText_Basic)
    }
    
    @Test func init_Table_Basic() {
        let sv = TSV(table: tsvTable_Basic)
        
        #expect(sv.table == tsvTable_Basic)
        #expect(sv.text == tsvRawText_Basic)
    }
}

// MARK: - Single column

@Suite struct TSV_SingleColumn_Tests {
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
    
    @Test func init_RawText_SingleColumn() {
        let sv = TSV(text: tsvRawText_SingleColumn)
        
        #expect(sv.table == tsvTable_SingleColumn)
        #expect(sv.text == tsvRawText_SingleColumn)
    }
    
    @Test func init_Table_SingleColumn() {
        let sv = TSV(table: tsvTable_SingleColumn)
        
        #expect(sv.table == tsvTable_SingleColumn)
        #expect(sv.text == tsvRawText_SingleColumn)
    }
}

// MARK: - Quoted fields

@Suite struct TSV_QuotedFields_Tests {
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
    
    @Test func init_RawText_QuotedFields() {
        let sv = TSV(text: tsvRawText_QuotedFields)
        
        #expect(sv.table == tsvTable_QuotedFields)
        #expect(sv.text == tsvRawText_QuotedFields)
    }
}
