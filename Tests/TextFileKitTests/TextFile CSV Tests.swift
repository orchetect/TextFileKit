//
//  TextFile CSV Tests.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TextFileKit
import Testing
import TestingExtensions

@Suite struct CSV_Tests {
    @Test func init_Default() {
        let sv = TextFile.CSV()
        
        #expect(sv.table == [])
    }
}

// MARK: - Basic

private let csvRawText_Basic = """
    header1,header2,header3
    1,2,3
    a,b,c
    """

private let csvTable_Basic: StringTable = [
    ["header1", "header2", "header3"],
    ["1", "2", "3"],
    ["a", "b", "c"]
]

extension CSV_Tests {
    @Test func init_RawText_Basic() {
        let sv = TextFile.CSV(rawText: csvRawText_Basic)
        
        #expect(sv.table == csvTable_Basic)
        #expect(sv.rawText == csvRawText_Basic)
    }
    
    @Test func init_Table_Basic() {
        let sv = TextFile.CSV(table: csvTable_Basic)
        
        #expect(sv.table == csvTable_Basic)
        #expect(sv.rawText == csvRawText_Basic)
    }
}

// MARK: - Single column

private let csvRawText_SingleColumn = """
    header1
    1
    a
    """

private let csvTable_SingleColumn: StringTable = [
    ["header1"],
    ["1"],
    ["a"]
]

extension CSV_Tests {
    @Test func init_RawText_SingleColumn() {
        let sv = TextFile.CSV(rawText: csvRawText_SingleColumn)
        
        #expect(sv.rawText == csvRawText_SingleColumn)
        #expect(sv.table == csvTable_SingleColumn)
    }
    
    @Test func init_Table_SingleColumn() {
        let sv = TextFile.CSV(table: csvTable_SingleColumn)
        
        #expect(sv.table == csvTable_SingleColumn)
        #expect(sv.rawText == csvRawText_SingleColumn)
    }
}

// MARK: - Quoted fields

private let csvRawText_QuotedFields = #"""
header1,"header, 2",header3
1,2,"3 ""quoted"" here"
"one line
another line",b,c
q,w,"e
""quoted"", stuff"
"""",a,""""""
"""#

private let csvTable_QuotedFields: StringTable = [
    ["header1", "header, 2", "header3"],
    ["1", "2", "3 \"quoted\" here"],
    ["one line\nanother line", "b", "c"],
    ["q", "w", "e\n\"quoted\", stuff"],
    ["\"", "a", "\"\""]
]

extension CSV_Tests {
    @Test func init_RawText_QuotedFields() {
        let sv = TextFile.CSV(rawText: csvRawText_QuotedFields)
        
        #expect(sv.table == csvTable_QuotedFields)
        #expect(sv.rawText == csvRawText_QuotedFields)
    }
    
    @Test func interFieldQuotes() {
        func parse(_ rawCSV: String) -> StringTable {
            TextFile.CSV.parseCSV(text: rawCSV)
        }
        #expect(parse("\"a\"") == [["a"]])
        #expect(parse("\"\"\"\"") == [["\""]])
        #expect(parse("\"\"\"a\"\"\"") == [["\"a\""]])
    }
}

// MARK: - Comma-Containing fields

private let csvRawText_CommaContainingFields = #"""
header1,header2,header3
data one,"""data, two""",data three
some one,"""some, two A"", ""some, two B""",some three
other one,"""other,, two""",other three
item1,$4.50,description1
item2,"$1,720.00",description2
item3,-$4.50,description3
item4,"-$1,720.00",description4
"""#

private let csvTable_CommaContainingFields: StringTable = [
    ["header1", "header2", "header3"],
    ["data one", "\"data, two\"", "data three"],
    ["some one", "\"some, two A\", \"some, two B\"", "some three"],
    ["other one", "\"other,, two\"", "other three"],
    ["item1", "$4.50", "description1"],
    ["item2", "$1,720.00", "description2"],
    ["item3", "-$4.50", "description3"],
    ["item4", "-$1,720.00", "description4"]
]

extension CSV_Tests {
    @Test func init_RawText_CommaContainingFields() {
        let sv = TextFile.CSV(rawText: csvRawText_CommaContainingFields)
        
        #expect(sv.table == csvTable_CommaContainingFields)
        #expect(sv.rawText == csvRawText_CommaContainingFields)
    }
    
    @Test func init_stringTable_CommaContainingFields() {
        let sv = TextFile.CSV(table: csvTable_CommaContainingFields)
        
        #expect(sv.table == csvTable_CommaContainingFields)
        #expect(sv.rawText == csvRawText_CommaContainingFields)
    }
}

// MARK: - BOM (Byte Order Mark) Tests

extension CSV_Tests {
    static let utf8_BOM_Test_Table: StringTable = [
        ["Field1", "Field2"],
        ["Row1A", "Row1B"],
        ["Row2A", "Row2B"]
    ]
    
    @Test func utf8BOM_initURL() throws {
        let url = try #require(try TestResource.TextFiles.utf8_BOM_Test_csv.url())
        
        let sv = try TextFile.CSV(file: url)
        
        let table = sv.table
        try #require(table.count == 3)
        #expect(table[0] == Self.utf8_BOM_Test_Table[0])
        #expect(table[1] == Self.utf8_BOM_Test_Table[1])
        #expect(table[2] == Self.utf8_BOM_Test_Table[2])
    }
    
    @Test func utf8BOM_initRawData() throws {
        let data = try #require(try TestResource.TextFiles.utf8_BOM_Test_csv.data())
        
        let sv = try TextFile.CSV(rawData: data)
        
        let table = sv.table
        try #require(table.count == 3)
        #expect(table[0] == Self.utf8_BOM_Test_Table[0])
        #expect(table[1] == Self.utf8_BOM_Test_Table[1])
        #expect(table[2] == Self.utf8_BOM_Test_Table[2])
    }
}
