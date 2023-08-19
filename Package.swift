// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftCSV",
    platforms: [
        .macOS("10.10"), .iOS("9.0"), .tvOS("9.2"), .watchOS("2.2")
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
