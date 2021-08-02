//
//  Utilities.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//

import Foundation

extension String {
    
    /// Wrap a string with double-quotes.
    @inlinable internal var quoted: Self {
        "\"\(self)\""
    }
    
}
