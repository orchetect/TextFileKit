//
//  API-0.4.0.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2018-2025 Steffan Andrews • Licensed under MIT License
//

// @_documentation(visibility: internal)
// @available(*, deprecated, message: "The `TextFile` namespace has been removed and the package has been renamed to `TextFile`. Use namespaced types directly as top-level types.")
// enum TextFile { }

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "TextFileDecodeError")
public typealias ParserError = TextFileDecodeError

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "DelimitedTextFormat")
public typealias DelimitedFormat = DelimitedTextFormat
