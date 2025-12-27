// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornIntelligenceAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornIntelligenceAdapters", targets: ["PopcornIntelligenceAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornIntelligence"),
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornTVSeries")
    ],

    targets: [
        .target(
            name: "PopcornIntelligenceAdapters",
            dependencies: [
                .product(name: "IntelligenceComposition", package: "PopcornIntelligence"),
                .product(name: "IntelligenceDomain", package: "PopcornIntelligence"),
                .product(name: "IntelligenceInfrastructure", package: "PopcornIntelligence"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ]
        ),
        .testTarget(
            name: "PopcornIntelligenceAdaptersTests",
            dependencies: ["PopcornIntelligenceAdapters"]
        )
    ]
)
