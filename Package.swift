// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "TextFileKit",
	
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TextFileKit",
            targets: ["TextFileKit"])
    ],
	
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/orchetect/OTCore", from: "1.1.0")
    ],
	
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TextFileKit",
            dependencies: ["OTCore"]),
        .testTarget(
            name: "TextFileKitTests",
            dependencies: ["TextFileKit"])
    ]
	
)
