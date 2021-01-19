//
//  TextFile TSV.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2020-08-19.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

@_implementationOnly import OTCore

extension TextFile {
	
	// tested with Google Sheets, Microsoft Excel, and Apple Numbers
	
	/// CUSTOM SHARED:
	/// TSV (Tab-Separated Values) text file format.
	public struct TSV: StringArrayTableRepresentable {
		
		// consts
		
		internal static let sepChar: Character = "\t"
		internal static let newLineChar: Character = Character.newLine
		
		public static let fileExtension = "tsv"
		
		// vars
		
		public var table: StringTable = []
		
		// init
		
		public init(table: StringTable = []) {
			self.table = table
		}
		
		public init(rawData: String) {
			table = Self.parseTSV(text: rawData)
		}
		
		// rawData
		
		public var rawData: String {
			
			table.map ({ row in
				
				row.map ({ textString in
					
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
					
				})
				.joined(separator: Self.sepChar.string)
			})
			.joined(separator: Self.newLineChar.string)
			
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
