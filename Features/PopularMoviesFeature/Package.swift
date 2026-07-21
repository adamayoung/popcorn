// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopularMoviesFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "PopularMoviesFeature", targets: ["PopularMoviesFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "PopularMoviesFeature",
            dependencies: [
                "DesignSystem",
                "Presentation",
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "PopularMoviesFeatureTests",
            dependencies: [
                "PopularMoviesFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ]
        ),
        .testTarget(
            name: "PopularMoviesFeatureSnapshotTests",
            dependencies: [
                "PopularMoviesFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
