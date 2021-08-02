//
//  StringTable.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//

/// String table addressed as `self[row][column]`, `self[row, column]` or `self[safe: row, column]`.
public typealias StringTable = [[String]]

extension StringTable {
    
    /// Number of rows in the string table.
    public var rowCount: Int {
        
        count
        
    }
    
    /// Number of rows in the columns table.
    /// The first row determines number of columns for the entire table.
    public var columnCount: Int {
        
        first?.count ?? 0
        
    }
    
    /// Access a cell of the table.
    /// Ensure the cell exists before accessing it or an exception will be thrown, the same as standard array subscript behavior.
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
            guard self.indices.contains(row),
                  self[row].indices.contains(col)
            else { return nil }
            
            return self[row][col]
        }
        set {
            guard row < self.rowCount,
                  col < self[row].count
            else { return }
            
            if let newValue = newValue {
                self[row][col] = newValue
            }
        }
        
    }
    
}
