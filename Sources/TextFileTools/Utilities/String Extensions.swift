//
//  String Extensions.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

extension String {
    /// Wrap a string with double-quotes.
    @inlinable var quoted: Self {
        "\"\(self)\""
    }
    
    /// Fix non-standard line-breaks in a text block.
    var fixedLineBreaks: Self {
        // TODO: hacky line-ending conversion
        replacingOccurrences(of: "\r\n", with: "\n")
    }
}
