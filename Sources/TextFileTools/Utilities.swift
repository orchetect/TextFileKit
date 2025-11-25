//
//  Utilities.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension String {
    /// Wrap a string with double-quotes.
    @inlinable var quoted: Self {
        "\"\(self)\""
    }
}
