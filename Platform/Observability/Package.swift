// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Observability",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "Observability", targets: ["Observability"]),
        .library(name: "ObservabilityTestHelpers", targets: ["ObservabilityTestHelpers"])
    ],

    targets: [
        .target(name: "Observability"),
        .target(
            name: "ObservabilityTestHelpers",
            dependencies: ["Observability"]
        ),
        .testTarget(
            name: "ObservabilityTests",
            dependencies: ["Observability"]
        )
    ]
)
