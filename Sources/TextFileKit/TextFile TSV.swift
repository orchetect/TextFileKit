//
//  TextFile TSV.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//

import Foundation

extension TextFile {
    
    // tested with Google Sheets, Microsoft Excel, and Apple Numbers
    
    /// TSV (Tab-Separated Values) text file format.
    public struct TSV: StringArrayTableRepresentable {
        
        // MARK: - Constants
        
        internal static let sepChar: Character = "\t"
        internal static let newLineChar: Character = "\n"
        
        public static let fileExtension = "tsv"
        
        // MARK: - Variables
        
        public var table: StringTable = []
        
        // MARK: - Init
        
        public init(table: StringTable = []) {
            self.table = table
        }
        
        public init(rawText: String) {
            table = Self.parseTSV(text: rawText)
        }
        
        // MARK: - RawText
        
        public var rawText: String {
            
            table.map { row in
                
                row.map { textString in
                    
                    var outString = textString
                    var needsQuoteWrapping = false
                    
                    // wrap string in double-quotes if it contains a tab or a newline
                    if outString.contains("\t")
                        || outString.contains(Self.newLineChar)
                    { needsQuoteWrapping = true }
                    
                    // escape double-quotes
                    // (only necessary if the string needs to be wrote-wrapped for another reason (ie: string contains a tab char))
                    if outString.contains("\"")
                        && needsQuoteWrapping
                    {
                        outString = outString.replacingOccurrences(of: "\"", with: "\"\"")
                    }
                    
                    if needsQuoteWrapping {
                        outString = outString.quoted
                    }
                    
                    return outString
                    
                }
                .joined(separator: String(Self.sepChar))
                
            }
            .joined(separator: String(Self.newLineChar))
            
        }
        
    }
    
}

extension TextFile.TSV {
    
    internal static func parseTSV(text: String) -> StringTable {
        
        // prep
        
        let text = text + String(newLineChar) // append newline to assist the parser
        
        var result: StringTable = []
        
        // flags and registers
        var quoteOpen = false
        var lastCharWasMidstreamQuote = false
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
                if record.count == 1 && record[0] == "" {
                    record = []
                    return
                }
                
                if record.count > 0 {
                    result.append(record)
                    record = []
                }
            }
            
            // char
            
            switch char {
            case sepChar:
                // close quoted field if preceding char was a quote
                if lastCharWasMidstreamQuote == true { quoteOpen = false }
                
                // close field, if we're not in the middle of a quoted field
                if !quoteOpen {
                    closeField()
                } else {
                    fieldString.append(char)
                }
                
                lastCharWasMidstreamQuote = false
                
            case "\"":
                // consider it a quoted field if a quote is the first character
                if !quoteOpen && fieldString.count == 0 {
                    quoteOpen = true
                    continue
                }
                
                if fieldString.count > 0 {
                    
                    if quoteOpen {
                        if lastCharWasMidstreamQuote {
                            fieldString += "\""
                            lastCharWasMidstreamQuote = false
                        } else {
                            lastCharWasMidstreamQuote = true
                        }
                    } else {
                        fieldString.append(char)
                        lastCharWasMidstreamQuote = false
                    }
                    
                }
                
            case newLineChar:
                // close record, if we're not in the middle of a quoted field
                if !quoteOpen || (quoteOpen && lastCharWasMidstreamQuote) {
                    closeField()
                    closeRecord()
                } else {
                    fieldString.append(char)
                }
                
                lastCharWasMidstreamQuote = false
                
            default:
                fieldString.append(char)
                
                lastCharWasMidstreamQuote = false
                
            }
            
        }
        
        // return
        
        return result
        
    }
    
}
