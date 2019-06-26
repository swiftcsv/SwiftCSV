// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftCSV",
    products: [
        .library(
            name: "SwiftCSV",
            targets: ["SwiftCSV"]),
    ],
    dependencies: [], // No dependencies
    swiftLanguageVersions: [.v4, .v5],
    targets: [
        .target(
            name: "SwiftCSV",
            dependencies: [],
            path: "SwiftCSV"),
        .testTarget(
            name: "SwiftCSVTests",
            dependencies: ["SwiftCSV"],
            path: "SwiftCSVTests"),
    ]
)
