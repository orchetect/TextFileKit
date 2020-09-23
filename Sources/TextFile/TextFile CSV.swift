//
//  TextFile CSV.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2020-08-19.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation
import OTCore

extension TextFile {
	
	// CSV format: https://en.wikipedia.org/wiki/Comma-separated_values
	
	// tested with Google Sheets, Microsoft Excel, and Apple Numbers
	
	/// CUSTOM SHARED:
	/// CSV (Comma-Separated Values) text file format.
	public struct CSV: StringArrayTableRepresentable {
		
		// consts
		
		internal static let sepChar: Character = ","
		internal static let newLineChar: Character = Character.newLine
		
		public static let fileExtension = "csv"
		
		// vars
		
		public var table: StringTable = []
		
		// init
		
		public init(table: StringTable = []) {
			self.table = table
		}
		
		public init(rawData: String) {
			table = Self.parseCSV(text: rawData)
		}
		
		// rawData
		
		public var rawData: String {
			
			table.map ({ row in
				
				row.map ({ textString in
					
					var outString = textString
					
					// escape double-quotes
					outString = outString.replacingOccurrences(of: "\"", with: "\"\"")
					
					// wrap string in double-quotes if it contains a comma, escaped double-quotes, or newline chars
					if outString.contains(",")
						|| outString.contains("\"")
						|| outString.contains(Self.newLineChar)
					{ outString = outString.quoted }
					
					return outString
					
				})
				.joined(separator: Self.sepChar.string)
			})
				.joined(separator: Self.newLineChar.string)
			
		}
		
	}
	
}

extension TextFile.CSV {
	
	internal static func parseCSV(text: String) -> StringTable {
		
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
				// close field, if we're not in the middle of a quoted field
				if !quoteOpen || (quoteOpen && lastCharWasMidstreamQuote) {
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
					
					if lastCharWasMidstreamQuote {
						fieldString += "\""
						lastCharWasMidstreamQuote = false
					} else {
						lastCharWasMidstreamQuote = true
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
