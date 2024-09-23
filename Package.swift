// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextFileKit",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "TextFileKit",
            targets: ["TextFileKit"]
        )
    ],
    targets: [
        .target(
            name: "TextFileKit",
            dependencies: []
        ),
        .testTarget(
            name: "TextFileKitTests",
            dependencies: ["TextFileKit"]
        )
    ]
)
