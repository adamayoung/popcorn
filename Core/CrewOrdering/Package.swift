// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CrewOrdering",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "CrewOrdering", targets: ["CrewOrdering"])
    ],

    targets: [
        .target(name: "CrewOrdering"),
        .testTarget(
            name: "CrewOrderingTests",
            dependencies: ["CrewOrdering"]
        )
    ]
)
