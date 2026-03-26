//
//  API-0.4.1.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

extension StringTable {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "subscript(safeRow:col:)")
    public subscript(safe row: Int, col: Int) -> Element.Element? {
        get { self[safeRow: row, col: col] }
        set { self[safeRow: row, col: col] = newValue }
    }
}
