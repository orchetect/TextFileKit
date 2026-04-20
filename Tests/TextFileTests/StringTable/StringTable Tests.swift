//
//  StringTable Tests.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Testing
@testable import TextFile

struct StringTableTests {
    @Test
    func read() {
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

    @Test
    func write() {
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

    @Test
    func equatable() {
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

    @Test
    func numberOfRowsColumns() {
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

    @Test
    func columnIndex_WithName() {
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

    @Test
    func columnIndex_WithName_caseInsensitive() {
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

    @Test
    func columnIndex_WithName_trimWhitespace() {
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

    @Test
    func columnIndex_WithName_caseInsensitive_trimWhitespace() {
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

    @Test
    func matrixSubscript() {
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

    @Test
    func safeRowColSubscript() {
        var st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A"]
        ]

        // existing

        #expect(st[safeRow: 0, col: 0] == "1A")
        #expect(st[safeRow: 0, col: 1] == "1B")

        st[safeRow: 0, col: 1] = "1Bnew"

        #expect(st[safeRow: 0, col: 1] == "1Bnew")

        // non-existing

        #expect(st[safeRow: 2, col: 1] == nil)

        st[safeRow: 0, col: 2] = "1C"
        #expect(st[safeRow: 0, col: 2] == nil)

        st[safeRow: 3, col: 0] = "4A"
        #expect(st[safeRow: 3, col: 0] == nil)
    }

    @Test
    func row_ColName_Subscript() {
        var st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A"]
        ]

        // existing

        #expect(st[row: 1, col: "1A"] == "2A")
        #expect(st[row: 1, col: "1B"] == "2B")

        st[row: 1, col: "1B"] = "1Bnew"

        #expect(st[row: 1, col: "1B"] == "1Bnew")
    }

    @Test
    func row_ColName_Subscript_outOfBoundsSet() async {
        #if os(macOS)
        await #expect(processExitsWith: .failure) {
            var st: StringTable = [
                ["1A", "1B"],
                ["2A", "2B"],
                ["3A"]
            ]

            // set { }
            st[row: 1, col: "1C"] = "2C"
        }
        #endif
    }

    @Test
    func row_ColName_Subscript_outOfBoundsGet() async {
        #if os(macOS)
        await #expect(processExitsWith: .failure) {
            let st: StringTable = [
                ["1A", "1B"],
                ["2A", "2B"],
                ["3A"]
            ]

            // get { }
            _ = st[row: 1, col: "1C"]
        }
        #endif
    }

    @Test
    func row_ColName_Subscript_outOfBoundsModify() async {
        #if os(macOS)
        await #expect(processExitsWith: .failure) {
            var st: StringTable = [
                ["1A", "1B"],
                ["2A", "2B"],
                ["3A"]
            ]

            // _modify { }
            st[row: 1, col: "1C"].append("-")
        }
        #endif
    }

    @Test
    func safeRow_ColName_Subscript() {
        var st: StringTable = [
            ["1A", "1B"],
            ["2A", "2B"],
            ["3A"]
        ]

        // existing

        #expect(st[safeRow: 1, col: "1A"] == "2A")
        #expect(st[safeRow: 1, col: "1B"] == "2B")

        st[safeRow: 1, col: "1B"] = "1Bnew"

        #expect(st[safeRow: 1, col: "1B"] == "1Bnew")

        // non-existing

        #expect(st[safeRow: 2, col: "1B"] == nil)

        st[safeRow: 1, col: "1C"] = "2C"
        #expect(st[safeRow: 1, col: "1C"] == nil)

        st[safeRow: 3, col: "1A"] = "4A"
        #expect(st[safeRow: 3, col: "1A"] == nil)
    }

    @Test
    func columnCharCountsA() {
        let table: StringTable = []
        let ranges = table.columnCharCounts
        #expect(ranges.isEmpty)
    }

    @Test
    func columnCharCountsB() {
        let table: StringTable = [[]]
        let ranges = table.columnCharCounts
        #expect(ranges.isEmpty)
    }

    @Test
    func columnCharCountsC() {
        let table: StringTable = [["H1"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 1)

        #expect(ranges[0] == 2 ... 2)
    }

    @Test
    func columnCharCountsD() {
        let table: StringTable = [["H1", "H2", "H3"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 3)

        #expect(ranges[0] == 2 ... 2)
        #expect(ranges[1] == 2 ... 2)
        #expect(ranges[2] == 2 ... 2)
    }

    @Test
    func columnCharCountsE() {
        let table: StringTable = [["H1", "", "H3_"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 3)

        #expect(ranges[0] == 2 ... 2)
        #expect(ranges[1] == 0 ... 0)
        #expect(ranges[2] == 3 ... 3)
    }

    @Test
    func columnCharCountsF() {
        let table: StringTable = [["H1"], [""], ["R2"]]
        let ranges = table.columnCharCounts
        #expect(ranges.count == 1)

        #expect(ranges[0] == 0 ... 2)
    }

    @Test
    func columnCharCountsG() {
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
