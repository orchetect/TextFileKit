//
//  TextFile CSV Tests.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TextFileKit
import Testing

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
"""#

private let csvTable_CommaContainingFields: StringTable = [
    ["header1", "header2", "header3"],
    ["data one", "\"data, two\"", "data three"],
    ["some one", "\"some, two A\", \"some, two B\"", "some three"],
    ["other one", "\"other,, two\"", "other three"]
]

extension CSV_Tests {
    @Test func init_RawText_CommaContainingFields() {
        let sv = TextFile.CSV(rawText: csvRawText_CommaContainingFields)
        
        #expect(sv.table == csvTable_CommaContainingFields)
        #expect(sv.rawText == csvRawText_CommaContainingFields)
    }
}
