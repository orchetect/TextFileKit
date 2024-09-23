//
//  Utilities.swift
//  TextFileKit • https://github.com/orchetect/TextFileKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension String {
    /// Wrap a string with double-quotes.
    @inlinable var quoted: Self {
        "\"\(self)\""
    }
}
