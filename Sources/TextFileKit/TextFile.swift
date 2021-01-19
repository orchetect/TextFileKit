//
//  TextFile.swift
//  TextFileKit
//
//  Created by Steffan Andrews on 2020-08-19.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

/// CUSTOM SHARED:
/// Family of Text File parsing and constructing entities.
public enum TextFile {
	
}

/// CUSTOM SHARED:
/// String table addressed as `self[row][column]`.
public typealias StringTable = [[String]]

/// CUSTOM SHARED:
/// Protocol describing file formats which can be serialized/deserialized to/from a String Array table of rows and columns.
public protocol StringArrayTableRepresentable {
	
	/// Raw data store as an Array table addressed as `self[row][column]`.
	var table: StringTable { get set }
	
	/// (Computed property) Raw string content of the file.
	var rawData: String { get }
	
	/// Initialize from an Array table addressed as `self[row][column]`.
	init(table: StringTable)
	
	/// Initialize from raw file data.
	init(rawData: String)
	
}
