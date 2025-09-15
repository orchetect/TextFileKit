// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TextFileKit",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "TextFileKit", targets: ["TextFileKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-testing-extensions", .upToNextMajor(from: "0.2.4")),
    ],
    targets: [
        .target(name: "TextFileKit"),
        .testTarget(
            name: "TextFileKitTests",
            dependencies: [
                "TextFileKit",
                .product(name: "TestingExtensions", package: "swift-testing-extensions")
            ],
            resources: [.copy("TestResource/Text Files")]
        )
    ]
)
