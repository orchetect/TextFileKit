//
//  Utilities.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension String {
    /// Wrap a string with double-quotes.
    @inlinable internal var quoted: Self {
        "\"\(self)\""
    }
}
