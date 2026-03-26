//
//  StringTable Tests.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import Testing
@testable import TextFile

@Suite struct StringTableTests {
    @Test func read() async {
        let st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        #expect(st[0][0] == "1A")
        #expect(st[0][1] == "1B")
        
        #expect(st[2][0] == "3A")
        #expect(st[2][1] == "3B")
    }
    
    @Test func write() async {
        var st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        // update
        
        #expect(st[1][0] == "2A")
        
        st[1][0] = "2Anew"
        
        #expect(st[1][0] == "2Anew")
        
        // append
        
        st.append(["4A", "4B"])
        
        #expect(st[3][0] == "4A")
        #expect(st[3][1] == "4B")
    }
    
    @Test func equatable() async {
        let st1: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        let st2: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        #expect(st1 == st2)
    }
    
    @Test func numberOfRowsColumns() async {
        var st: StringTable
        
        st = []
        
        #expect(st.rowCount == 0)
        #expect(st.columnCount == 0)
        
        st = [["-", "-"]]
        
        #expect(st.rowCount == 1)
        #expect(st.columnCount == 2)
        
        st = [
            ["-", "-", "-"],
            ["-", "-", "-"]
        ]
        
        #expect(st.rowCount == 2)
        #expect(st.columnCount == 3)
        
        // edge cases
        
        st = [
            ["-"],
            ["-", "-", "-"]
        ]
        
        #expect(st.rowCount == 2)
        #expect(st.columnCount == 1)
    }
    
    @Test func columnIndex_WithName() async {
        let st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        #expect(st.columnIndex(withName: "") == nil)
        #expect(st.columnIndex(withName: " ") == nil)
        #expect(st.columnIndex(withName: "Foo") == nil)
        
        #expect(st.columnIndex(withName: "1A") == 0)
        #expect(st.columnIndex(withName: "1B") == 1)
        
        #expect(st.columnIndex(withName: "1a") == nil)
        #expect(st.columnIndex(withName: "1b") == nil)
        
        #expect(st.columnIndex(withName: "1A ") == nil)
        #expect(st.columnIndex(withName: " 1B") == nil)
        
        #expect(st.columnIndex(withName: "1a ") == nil)
        #expect(st.columnIndex(withName: " 1b") == nil)
    }
    
    @Test func columnIndex_WithName_caseInsensitive() async {
        let st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        #expect(st.columnIndex(withName: "", caseInsensitive: true) == nil)
        #expect(st.columnIndex(withName: " ", caseInsensitive: true) == nil)
        #expect(st.columnIndex(withName: "Foo", caseInsensitive: true) == nil)
        
        #expect(st.columnIndex(withName: "1A", caseInsensitive: true) == 0)
        #expect(st.columnIndex(withName: "1B", caseInsensitive: true) == 1)
        
        #expect(st.columnIndex(withName: "1a", caseInsensitive: true) == 0)
        #expect(st.columnIndex(withName: "1b", caseInsensitive: true) == 1)
        
        #expect(st.columnIndex(withName: "1A ", caseInsensitive: true) == nil)
        #expect(st.columnIndex(withName: " 1B", caseInsensitive: true) == nil)
        
        #expect(st.columnIndex(withName: "1a ", caseInsensitive: true) == nil)
        #expect(st.columnIndex(withName: " 1b", caseInsensitive: true) == nil)
    }
    
    @Test func columnIndex_WithName_trimWhitespace() async {
        let st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        #expect(st.columnIndex(withName: "", trimWhitespace: true) == nil)
        #expect(st.columnIndex(withName: " ", trimWhitespace: true) == nil)
        #expect(st.columnIndex(withName: "Foo", trimWhitespace: true) == nil)
        
        #expect(st.columnIndex(withName: "1A", trimWhitespace: true) == 0)
        #expect(st.columnIndex(withName: "1B", trimWhitespace: true) == 1)
        
        #expect(st.columnIndex(withName: "1a", trimWhitespace: true) == nil)
        #expect(st.columnIndex(withName: "1b", trimWhitespace: true) == nil)
        
        #expect(st.columnIndex(withName: "1A ", trimWhitespace: true) == 0)
        #expect(st.columnIndex(withName: " 1B", trimWhitespace: true) == 1)
        
        #expect(st.columnIndex(withName: "1a ", trimWhitespace: true) == nil)
        #expect(st.columnIndex(withName: " 1b", trimWhitespace: true) == nil)
    }
    
    @Test func columnIndex_WithName_caseInsensitive_trimWhitespace() async {
        let st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        #expect(st.columnIndex(withName: "", caseInsensitive: true, trimWhitespace: true) == nil)
        #expect(st.columnIndex(withName: " ", caseInsensitive: true, trimWhitespace: true) == nil)
        #expect(st.columnIndex(withName: "Foo", caseInsensitive: true, trimWhitespace: true) == nil)
        
        #expect(st.columnIndex(withName: "1A", caseInsensitive: true, trimWhitespace: true) == 0)
        #expect(st.columnIndex(withName: "1B", caseInsensitive: true, trimWhitespace: true) == 1)
        
        #expect(st.columnIndex(withName: "1a", caseInsensitive: true, trimWhitespace: true) == 0)
        #expect(st.columnIndex(withName: "1b", caseInsensitive: true, trimWhitespace: true) == 1)
        
        #expect(st.columnIndex(withName: "1A ", caseInsensitive: true, trimWhitespace: true) == 0)
        #expect(st.columnIndex(withName: " 1B", caseInsensitive: true, trimWhitespace: true) == 1)
        
        #expect(st.columnIndex(withName: "1a ", caseInsensitive: true, trimWhitespace: true) == 0)
        #expect(st.columnIndex(withName: " 1b", caseInsensitive: true, trimWhitespace: true) == 1)
    }
    
    @Test func matrixSubscript() async {
        var st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A", "3B"]
        ]
        
        #expect(st[0, 0] == "1A")
        #expect(st[0, 1] == "1B")
        
        st[0, 1] = "1Bnew"
        #expect(st[0, 1] == "1Bnew")
    }
    
    @Test func safeSubscript() async {
        var st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A"]
        ]
        
        // existing
        
        #expect(st[safe: 0, 0] == "1A")
        #expect(st[safe: 0, 1] == "1B")
        
        st[safe: 0, 1] = "1Bnew"
        
        #expect(st[safe: 0, 1] == "1Bnew")
        
        // non-existing
        
        #expect(st[safe: 2, 1] == nil)
        
        st[safe: 0, 2] = "1C"
        #expect(st[safe: 0, 2] == nil)
        
        st[safe: 3, 0] = "4A"
        #expect(st[safe: 3, 0] == nil)
    }
    
    @Test func columnCharCountsA() async {
        let table: StringTable = []
        let ranges = table.columnCharCounts
        #expect(ranges.count == 0)
    }
    
    @Test func columnCharCountsB() async {
        let table: StringTable = [[]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 0)
    }
    
    @Test func columnCharCountsC() async {
        let table: StringTable = [["H1"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 1)
        
        #expect(ranges[0] == 2 ... 2)
    }
    
    @Test func columnCharCountsD() async {
        let table: StringTable = [["H1", "H2", "H3"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 3)
        
        #expect(ranges[0] == 2 ... 2)
        #expect(ranges[1] == 2 ... 2)
        #expect(ranges[2] == 2 ... 2)
    }
    
    @Test func columnCharCountsE() async {
        let table: StringTable = [["H1", "", "H3_"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 3)
        
        #expect(ranges[0] == 2 ... 2)
        #expect(ranges[1] == 0 ... 0)
        #expect(ranges[2] == 3 ... 3)
    }
    
    @Test func columnCharCountsF() async {
        let table: StringTable = [["H1"], [""], ["R2"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 1)
        
        #expect(ranges[0] == 0 ... 2)
    }
    
    @Test func columnCharCountsG() async {
        let table: StringTable = [
            ["H1", "H2", "H3"],
            ["", "abc", "ab"]
        ]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 3)
        
        #expect(ranges[0] == 0 ... 2)
        #expect(ranges[1] == 2 ... 3)
        #expect(ranges[2] == 2 ... 2)
    }
}
