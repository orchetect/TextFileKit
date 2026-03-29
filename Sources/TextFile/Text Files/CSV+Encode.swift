//
//  CSV+Encode.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

extension CSV {
    public var text: String {
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
