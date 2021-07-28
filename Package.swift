// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "TextFileKit",
    
    products: [
        .library(
            name: "TextFileKit",
            targets: ["TextFileKit"])
    ],
    
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.1.10")
    ],
    
    targets: [
        .target(
            name: "TextFileKit",
            dependencies: ["OTCore"]),
        .testTarget(
            name: "TextFileKitTests",
            dependencies: ["TextFileKit"])
    ]
    
)
