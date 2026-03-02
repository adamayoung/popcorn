// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Analytics",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "Analytics", targets: ["Analytics"]),
        .library(name: "AnalyticsTestHelpers", targets: ["AnalyticsTestHelpers"])
    ],

    targets: [
        .target(name: "Analytics"),
        .target(
            name: "AnalyticsTestHelpers",
            dependencies: ["Analytics"]
        ),
        .testTarget(
            name: "AnalyticsTests",
            dependencies: ["Analytics"]
        )
    ]
)
