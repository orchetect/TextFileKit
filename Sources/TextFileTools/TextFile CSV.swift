//
//  TextFile CSV.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TextFile {
    // CSV format: https://en.wikipedia.org/wiki/Comma-separated_values
    
    // tested with Google Sheets, Microsoft Excel, and Apple Numbers
    
    /// CSV (Comma-Separated Values) text file format.
    public struct CSV: StringTableRepresentable {
        // MARK: - Constants
        
        static let sepChar: Character = ","
        static let newLineChar: Character = "\n"
        
        public static let fileExtension = "csv"
        
        // MARK: - Variables
        
        public var table: StringTable = []
        
        // MARK: - Init
        
        public init(table: StringTable = []) {
            self.table = table
        }
        
        public init(rawText: String) {
            table = Self.parseCSV(text: rawText)
        }
        
        // MARK: - rawText
        
        public var rawText: String {
            table.map { row in
                row.map { textString in
                    var outString = textString
                    
                    // escape double-quotes
                    outString = outString.replacingOccurrences(of: "\"", with: "\"\"")
                    
                    // wrap string in double-quotes if it contains a comma, escaped double-quotes, or newline chars
                    if outString.contains(",")
                        || outString.contains("\"")
                        || outString.contains(Self.newLineChar)
                    { outString = outString.quoted }
                    
                    return outString
                }
                .joined(separator: String(Self.sepChar))
            }
            .joined(separator: String(Self.newLineChar))
        }
    }
}

extension TextFile.CSV {
    static func parseCSV(text: String) -> StringTable {
        // prep
        
        let text = text + String(newLineChar) // append newline to assist the parser
        
        var result: StringTable = []
        
        // flags and registers
        var quoteOpen = false
        var previousCharWasMidstreamQuote = false
        var fieldString = ""
        var record: [String] = []
        
        // parse
        
        for char in text {
            // helpers
            
            func closeField() {
                record.append(fieldString)
                fieldString = ""
                quoteOpen = false
            }
            
            func closeRecord() {
                // if empty line, don't add it
                if record.count == 1, record[0] == "" {
                    record = []
                    return
                }
                
                if !record.isEmpty {
                    result.append(record)
                    record = []
                }
            }
            
            // char
            
            switch char {
            case sepChar:
                // close field, if we're not in the middle of a quoted field
                if !quoteOpen || (quoteOpen && previousCharWasMidstreamQuote) {
                    closeField()
                } else {
                    fieldString.append(char)
                }
                
                previousCharWasMidstreamQuote = false
                
            case "\"":
                // consider it a quoted field if a quote is the first character
                if !quoteOpen, fieldString.isEmpty {
                    quoteOpen = true
                    continue
                }
                
                if previousCharWasMidstreamQuote {
                    fieldString += "\""
                    previousCharWasMidstreamQuote = false
                } else {
                    previousCharWasMidstreamQuote = true
                }
                
            case newLineChar:
                // close record, if we're not in the middle of a quoted field
                if !quoteOpen || (quoteOpen && previousCharWasMidstreamQuote) {
                    closeField()
                    closeRecord()
                } else {
                    fieldString.append(char)
                }
                
                previousCharWasMidstreamQuote = false
                
            default:
                fieldString.append(char)
                
                previousCharWasMidstreamQuote = false
            }
        }
        
        // return
        
        return result
    }
}
