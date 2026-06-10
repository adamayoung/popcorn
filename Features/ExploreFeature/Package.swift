// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExploreFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "ExploreFeature", targets: ["ExploreFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornDiscover"),
        .package(path: "../../Contexts/PopcornTrending"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Platform/Observability"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "ExploreFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "Presentation",
                "Observability",
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "ExploreFeatureTests",
            dependencies: [
                "ExploreFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "DiscoverDomain", package: "PopcornDiscover"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "TrendingApplication", package: "PopcornTrending")
            ]
        ),
        .testTarget(
            name: "ExploreFeatureSnapshotTests",
            dependencies: [
                "ExploreFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
