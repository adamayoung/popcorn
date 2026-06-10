// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TVEpisodeDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "TVEpisodeDetailsFeature", targets: ["TVEpisodeDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/FeatureAccess"),
        .package(path: "../../Platform/Observability"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "TVEpisodeDetailsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "Presentation",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                "FeatureAccess",
                "Observability"
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
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "FeatureAccessTestHelpers", package: "FeatureAccess"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ]
        ),
        .testTarget(
            name: "TVEpisodeDetailsFeatureSnapshotTests",
            dependencies: [
                "TVEpisodeDetailsFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
