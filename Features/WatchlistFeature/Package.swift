// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "WatchlistFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "WatchlistFeature", targets: ["WatchlistFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "WatchlistFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "Presentation",
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "WatchlistFeatureTests",
            dependencies: [
                "WatchlistFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ]
        ),
        .testTarget(
            name: "WatchlistFeatureSnapshotTests",
            dependencies: [
                "WatchlistFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
