//
//  StringTable.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

/// String table addressed as `self[row][column]`, `self[row, column]` or `self[safe: row, column]`.
public typealias StringTable = [[String]]

extension StringTable {
    /// Number of rows in the string table.
    public var rowCount: Int {
        count
    }
    
    /// Number of columns in the string table.
    /// The first row determines number of columns for the entire table.
    public var columnCount: Int {
        first?.count ?? 0
    }
    
    /// Access a cell of the table.
    /// Ensure the cell exists before accessing it or an exception will be thrown,
    /// the same as standard array subscript behavior.
    public subscript(row: Int, col: Int) -> Element.Element {
        get {
            self[row][col]
        }
        set {
            self[row][col] = newValue
        }
    }
    
    /// Access a cell of the table.
    /// Get: Cells which do not exist will return `nil`.
    /// Set: Cells which do not exist will not be set.
    public subscript(safe row: Int, col: Int) -> Element.Element? {
        get {
            guard indices.contains(row),
                  self[row].indices.contains(col)
            else { return nil }
            
            return self[row][col]
        }
        set {
            guard row < rowCount,
                  col < self[row].count
            else { return }
            
            if let newValue = newValue {
                self[row][col] = newValue
            }
        }
    }
}

extension StringTable {
    /// Returns the min and max character count for each column.
    /// The `upperBound` can be useful for resizing columns to fit the column's data.
    ///
    /// - Returns: `[Column Index: Min Char Count ... Max Char Count]`
    public var columnCharCounts: [Int: ClosedRange<Int>] {
        reduce(into: [:]) { dict, rowValues in
            // iterate columns for current row
            for (columnOffset, rowValue) in rowValues.enumerated() {
                let cellCharCount = rowValue.count
                let defaultRange = cellCharCount ... cellCharCount
                
                // ensure all columns have a value, even if it's default of 0
                if dict[columnOffset] == nil {
                    dict[columnOffset] = defaultRange
                }
                
                // update stored range if cell character count is outside stored range
                var range = dict[columnOffset] ?? defaultRange
                if range.upperBound < cellCharCount {
                    range = range.lowerBound ... cellCharCount
                }
                if range.lowerBound > cellCharCount {
                    range = cellCharCount ... range.upperBound
                }
                if dict[columnOffset] != range { dict[columnOffset] = range }
            }
        }
    }
}
