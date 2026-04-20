//
//  API-0.4.0.swift
//  swift-textfile • https://github.com/orchetect/swift-textfile
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// @_documentation(visibility: internal)
// @available(
//     *,
//      deprecated,
//      message: "The `TextFile` namespace has been removed as the package has been renamed to `TextFile`. Use types as top-level types."
// )
// enum TextFile { }

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "TextFileDecodeError")
public typealias ParserError = TextFileDecodeError

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "DelimitedTextFormat")
public typealias DelimitedFormat = DelimitedTextFormat
