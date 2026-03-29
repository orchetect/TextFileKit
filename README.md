# swift-textfile

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-textfile%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/swift-textfile) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-textfile%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/swift-textfile) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-textfile/blob/main/LICENSE)

Read and write text files in Swift on Apple platforms and Linux.

- Support for text encoding detection

- Abstractions to read/write common delimited text file formats, including:

  - CSV (comma-separated values)

  - TSV (tab-separated values)


> [!NOTE]
>
> This library implements the full CSV and TSV specifications including proper escape sequences and text encoding auto-detection including handling of BOMs (byte order marks) to assure the widest compatibility. Limited support for reading malformed text encoding is implemented.

## Overview

The main types provided:

| Type            | Description                                                  |
| --------------- | ------------------------------------------------------------ |
| `PlainTextFile` | Read text file content from disk or from data in memory, with modestly robust text encoding auto-detection. |
| `CSV`           | Read and write CSV files. Reading implements the same text encoding auto-detection schema as `PlainTextFile`. |
| `TSV`           | Read and write TSV files. Reading implements the same text encoding auto-detection schema as `PlainTextFile`. |
| `StringTable`   | A basic abstraction for manipulating a matrix of strings (row and columns). |

## Installation

### Swift Package Manager (SPM)

To add this package to an Xcode app project, use:

 `https://github.com/orchetect/swift-textfile` as the URL.

To add this package to a Swift package, add the dependency to your package and target in Package.swift:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-textfile", from: "0.5.0")
    ],
    targets: [
        .target(
            dependencies: [
                .product(name: "TextFile", package: "swift-textfile")
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

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-textfile/blob/master/LICENSE) for details.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-textfile/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-textfile/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-textfile/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Legacy

This repository was formerly known as **swift-textfile-tools**, and previously **TextFileKit**.
