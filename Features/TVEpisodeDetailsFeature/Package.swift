// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TVEpisodeDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVEpisodeDetailsFeature", targets: ["TVEpisodeDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/TCAFoundation"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/FeatureAccess"),
        .package(path: "../../Platform/Observability"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "TVEpisodeDetailsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "TCAFoundation",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                "FeatureAccess",
                "Observability",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [
                .process("Localizable.xcstrings")
            ]
        ),
        .testTarget(
            name: "TVEpisodeDetailsFeatureTests",
            dependencies: [
                "AppDependencies",
                "TVEpisodeDetailsFeature",
                "TCAFoundation",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "FeatureAccessTestHelpers", package: "FeatureAccess"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ]
        ),
        .testTarget(
            name: "TVEpisodeDetailsFeatureSnapshotTests",
            dependencies: [
                "TVEpisodeDetailsFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "SnapshotTestHelpers"
            ]
        )
    ]
)
