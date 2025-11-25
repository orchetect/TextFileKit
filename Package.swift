// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "swift-textfile-tools",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "TextFileTools", targets: ["TextFileTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.2.4"),
    ],
    targets: [
        .target(name: "TextFileTools"),
        .testTarget(
            name: "TextFileToolsTests",
            dependencies: [
                "TextFileTools",
                .product(name: "TestingExtensions", package: "swift-testing-extensions")
            ],
            resources: [.copy("TestResource/Text Files")]
        )
    ]
)
