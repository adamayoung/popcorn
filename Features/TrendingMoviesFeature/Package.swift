// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrendingMoviesFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TrendingMoviesFeature", targets: ["TrendingMoviesFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornTrending"),
        .package(path: "../../Adapters/Kits/PopcornTrendingAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "TrendingMoviesFeature",
            dependencies: [
                "DesignSystem",
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                "PopcornTrendingAdapters",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "TrendingMoviesFeatureTests",
            dependencies: ["TrendingMoviesFeature"]
        )
    ]
)
