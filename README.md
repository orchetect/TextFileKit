# swift-textfile-tools

[![Platforms - macOS | iOS | tvOS | watchOS | visionOS](https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-blue.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.3-6.2](https://img.shields.io/badge/Swift-5.3–6.2-blue.svg?style=flat) [![Xcode 12-26](https://img.shields.io/badge/Xcode-12–26-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-textfile-tools/blob/main/LICENSE)

Read and write common delimited text file formats, including:

- CSV (comma-separated values)
- TSV (tab-separated values)

## Installation

### Swift Package Manager (SPM)

To add this package to an Xcode app project, use:

 `https://github.com/orchetect/swift-textfile-tools` as the URL.

To add this package to a Swift package, add the dependency to your package and target in Package.swift:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-textfile-tools", from: "0.3.0")
    ],
    targets: [
        .target(
            dependencies: [
                .product(name: "TextFileTools", package: "swift-textfile-tools")
            ]
        )
    ]
)
```

## Roadmap

Future library additions could bring additional table data text file formats.

## Author

Coded by a bunch of 🐹 hamsters in a trench coat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-textfile-tools/blob/master/LICENSE) for details.

This library was formerly known as SwiftHex.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-textfile-tools/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-textfile-tools/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-textfile-tools/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Legacy

This repository was formerly known as TextFileKit.
