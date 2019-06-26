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
