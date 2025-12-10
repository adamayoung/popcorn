// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExploreFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "ExploreFeature", targets: ["ExploreFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornDiscover"),
        .package(path: "../../Contexts/PopcornTrending"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Adapters/Contexts/PopcornDiscoverAdapters"),
        .package(path: "../../Adapters/Contexts/PopcornTrendingAdapters"),
        .package(path: "../../Adapters/Contexts/PopcornMoviesAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "ExploreFeature",
            dependencies: [
                "DesignSystem",
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                "PopcornDiscoverAdapters",
                "PopcornTrendingAdapters",
                "PopcornMoviesAdapters",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "ExploreFeatureTests",
            dependencies: ["ExploreFeature"]
        )
    ]
)
