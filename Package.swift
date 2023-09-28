// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftCSV",
    platforms: [
        .macOS("10.13"), .iOS("12.0"), .tvOS("12.0"), .watchOS("4.0")
    ],
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
            path: "SwiftCSVTests",
            resources: [
                .copy("TestData")
            ]),
    ],
    swiftLanguageVersions: [.v5, .v4_2]
)
