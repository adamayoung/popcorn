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
        .library(name: "Caching", targets: ["Caching"])
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
        .testTarget(
            name: "CachingTests",
            dependencies: ["Caching"]
        )
    ]
)
