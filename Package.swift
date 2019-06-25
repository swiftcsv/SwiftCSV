// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftCSV",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftCSV",
            targets: ["SwiftCSV"]),
    ],
    swiftLanguageVersions: [.v5],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftCSV",
            path: "SwiftCSV"),
        .testTarget(
            name: "SwiftCSVTests",
            dependencies: ["SwiftCSV"],
            path: "SwiftCSVTests"),
    ]
)
