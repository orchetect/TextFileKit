//
//  TSV+Encode.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension TSV {
    public var text: String {
        table.map { row in
            row.map { textString in
                var outString = textString
                var needsQuoteWrapping = false

                // wrap string in double-quotes if it contains a tab or a newline
                if outString.contains("\t")
                    || outString.contains(Self.newLineChar)
                { needsQuoteWrapping = true }

                // escape double-quotes
                // (only necessary if the string needs to be wrote-wrapped for another reason
                // (ie: string contains a tab char))
                if outString.contains("\""),
                   needsQuoteWrapping
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
