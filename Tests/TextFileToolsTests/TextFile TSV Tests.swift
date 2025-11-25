//
//  TextFile TSV Tests.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

@testable import TextFileTools
import Testing

@Suite struct TSV_Tests {
    @Test func init_Default() {
        let sv = TextFile.TSV()
        
        #expect(sv.table == [])
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
    @Test func init_RawText_Basic() {
        let sv = TextFile.TSV(rawText: tsvRawText_Basic)
        
        #expect(sv.table == tsvTable_Basic)
        #expect(sv.rawText == tsvRawText_Basic)
    }
    
    @Test func init_Table_Basic() {
        let sv = TextFile.TSV(table: tsvTable_Basic)
        
        #expect(sv.table == tsvTable_Basic)
        #expect(sv.rawText == tsvRawText_Basic)
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
    @Test func init_RawText_SingleColumn() {
        let sv = TextFile.TSV(rawText: tsvRawText_SingleColumn)
        
        #expect(sv.table == tsvTable_SingleColumn)
        #expect(sv.rawText == tsvRawText_SingleColumn)
    }
    
    @Test func init_Table_SingleColumn() {
        let sv = TextFile.TSV(table: tsvTable_SingleColumn)
        
        #expect(sv.table == tsvTable_SingleColumn)
        #expect(sv.rawText == tsvRawText_SingleColumn)
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
    @Test func init_RawText_QuotedFields() {
        let sv = TextFile.TSV(rawText: tsvRawText_QuotedFields)
        
        #expect(sv.table == tsvTable_QuotedFields)
        #expect(sv.rawText == tsvRawText_QuotedFields)
    }
}
