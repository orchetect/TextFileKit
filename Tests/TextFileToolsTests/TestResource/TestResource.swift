//
//  TestResource.swift
//  swift-textfile-tools • https://github.com/orchetect/swift-textfile-tools
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing
import TestingExtensions

// NOTE: DO NOT name any folders "Resources". Xcode will fail to build iOS targets.

/// Resources files on disk used for unit testing.
extension TestResource {
    enum TextFiles {
        static let utf8_BOM_Test_csv = TestResource.File(
            name: "utf8-bom-test", ext: "csv", subFolder: "Text Files"
        )
        
        static let utf8_BOM_CRLF_Test_csv = TestResource.File(
            name: "utf8-bom-crlf-test", ext: "csv", subFolder: "Text Files"
        )
    }
}
