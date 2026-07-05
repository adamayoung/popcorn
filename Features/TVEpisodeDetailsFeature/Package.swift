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
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "TVEpisodeDetailsFeature",
            dependencies: [
                "DesignSystem",
                "Presentation",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ],
            resources: [
                .process("Localizable.xcstrings")
            ]
        ),
        .testTarget(
            name: "TVEpisodeDetailsFeatureTests",
            dependencies: [
                "TVEpisodeDetailsFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
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
