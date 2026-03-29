//
//  API-0.5.1.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
#endif

extension StringTableRepresentable {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(text:)")
    public init(rawText: String) {
        self.init(text: rawText)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(data:encoding:)")
    public init(rawData: Data, encoding: String.Encoding? = nil) throws(TextFileDecodeError) {
        try self.init(data: rawData, encoding: encoding)
    }
}
