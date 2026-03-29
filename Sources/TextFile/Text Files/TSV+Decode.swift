//
//  TSV+Decode.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

extension TSV {
    static func parse(text: String) -> StringTable {
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
                // close quoted field if preceding char was a quote
                if previousCharWasMidstreamQuote == true { quoteOpen = false }
                
                // close field, if we're not in the middle of a quoted field
                if !quoteOpen {
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
                
                if !fieldString.isEmpty {
                    if quoteOpen {
                        if previousCharWasMidstreamQuote {
                            fieldString += "\""
                            previousCharWasMidstreamQuote = false
                        } else {
                            previousCharWasMidstreamQuote = true
                        }
                    } else {
                        fieldString.append(char)
                        previousCharWasMidstreamQuote = false
                    }
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
