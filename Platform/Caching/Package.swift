// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Caching",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "Caching", targets: ["Caching"]),
        .library(name: "CachingTestHelpers", targets: ["CachingTestHelpers"])
    ],

    dependencies: [
        .package(path: "../Observability")
    ],

    targets: [
        .target(
            name: "Caching",
            dependencies: [
                "Observability"
            ]
        ),
        .target(
            name: "CachingTestHelpers",
            dependencies: ["Caching"]
        ),
        .testTarget(
            name: "CachingTests",
            dependencies: ["Caching"]
        )
    ]
)
