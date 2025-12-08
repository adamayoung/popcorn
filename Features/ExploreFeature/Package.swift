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
        .package(path: "../../Kits/TrendingKit"),
        .package(path: "../../Kits/MoviesKit"),
        .package(path: "../../Adapters/Kits/TrendingKitAdapters"),
        .package(path: "../../Adapters/Kits/MoviesKitAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "ExploreFeature",
            dependencies: [
                "DesignSystem",
                .product(name: "TrendingApplication", package: "TrendingKit"),
                .product(name: "MoviesApplication", package: "MoviesKit"),
                "TrendingKitAdapters",
                "MoviesKitAdapters",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "ExploreFeatureTests",
            dependencies: ["ExploreFeature"]
        )
    ]
)
