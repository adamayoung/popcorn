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
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/TCAFoundation"),
        .package(path: "../../Contexts/PopcornDiscover"),
        .package(path: "../../Contexts/PopcornTrending"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Platform/Observability"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.18.7"
        )
    ],

    targets: [
        .target(
            name: "ExploreFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "TCAFoundation",
                "Observability",
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "ExploreFeatureTests",
            dependencies: [
                "ExploreFeature",
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
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            resources: [.copy("Views/__Snapshots__")]
        )
    ]
)
