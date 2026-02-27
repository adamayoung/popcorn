// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "WatchlistFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "WatchlistFeature", targets: ["WatchlistFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/TCAFoundation"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        ),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "WatchlistFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "TCAFoundation",
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "WatchlistFeatureTests",
            dependencies: [
                "WatchlistFeature",
                "TCAFoundation",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ]
        ),
        .testTarget(
            name: "WatchlistFeatureSnapshotTests",
            dependencies: [
                "WatchlistFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "SnapshotTestHelpers"
            ]
        )
    ]
)
