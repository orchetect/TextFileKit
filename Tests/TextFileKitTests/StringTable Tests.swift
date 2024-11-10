//
//  StringTable Tests.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TextFileKit
import Testing

@Suite struct StringTableTests {
    @Test func read() {
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
    
    @Test func write() {
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
    
    @Test func equatable() {
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
    
    @Test func numberOfRowsColumns() {
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
    
    @Test func matrixSubscript() {
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
    
    @Test func safeSubscript() {
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
    
    @Test func columnCharCountsA() {
        let table: StringTable = []
        let ranges = table.columnCharCounts
        #expect(ranges.count == 0)
    }
    
    @Test func columnCharCountsB() {
        let table: StringTable = [[]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 0)
    }
    
    @Test func columnCharCountsC() {
        let table: StringTable = [["H1"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 1)
        
        #expect(ranges[0] == 2 ... 2)
    }
    
    @Test func columnCharCountsD() {
        let table: StringTable = [["H1", "H2", "H3"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 3)
        
        #expect(ranges[0] == 2 ... 2)
        #expect(ranges[1] == 2 ... 2)
        #expect(ranges[2] == 2 ... 2)
    }
    
    @Test func columnCharCountsE() {
        let table: StringTable = [["H1", "", "H3_"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 3)
        
        #expect(ranges[0] == 2 ... 2)
        #expect(ranges[1] == 0 ... 0)
        #expect(ranges[2] == 3 ... 3)
    }
    
    @Test func columnCharCountsF() {
        let table: StringTable = [["H1"], [""], ["R2"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 1)
        
        #expect(ranges[0] == 0 ... 2)
    }
    
    @Test func columnCharCountsG() {
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
