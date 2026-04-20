// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "swift-textfile",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "TextFile", targets: ["TextFile"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.3.0")
    ],
    targets: [
        .target(name: "TextFile"),
        .testTarget(
            name: "TextFileTests",
            dependencies: [
                "TextFile",
                .product(name: "TestingExtensions", package: "swift-testing-extensions")
            ],
            resources: [.copy("TestResource/Text Files")]
        )
    ]
)
