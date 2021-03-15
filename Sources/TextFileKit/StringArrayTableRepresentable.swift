//
//  StringArrayTableRepresentable.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2021-03-15.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

/// Protocol describing file formats which can be encoded to/from a `StringTable` (String Array table of rows and columns).
public protocol StringArrayTableRepresentable {
	
	/// Raw data store as an Array table addressed as `self[row][column]`, `self[row, column]` or `self[safe: row, column]`.
	var table: StringTable { get set }
	
	/// (Computed property) Raw text content of the file.
	var rawText: String { get }
	
	/// Initialize from an Array table addressed as `self[row][column]`, `self[row, column]` or `self[safe: row, column]`.
	init(table: StringTable)
	
	/// Initialize from raw text content.
	init(rawText: String)
	
}
