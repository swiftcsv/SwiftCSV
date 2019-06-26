// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftCSV",
    platforms: [
        .macOS("10.10"), .iOS("8.0"), .tvOS("9.2"), .watchOS("2.2")
    ],
    swiftLanguageVersions: [.v5, .v4_2],
    dependencies: [], // No dependencies
    products: [
        .library(
            name: "SwiftCSV",
            targets: ["SwiftCSV"]),
    ],
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
