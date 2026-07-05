// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TVSeasonDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "TVSeasonDetailsFeature", targets: ["TVSeasonDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "TVSeasonDetailsFeature",
            dependencies: [
                "DesignSystem",
                "Presentation",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TVSeasonDetailsFeatureTests",
            dependencies: [
                "TVSeasonDetailsFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ]
        ),
        .testTarget(
            name: "TVSeasonDetailsFeatureSnapshotTests",
            dependencies: [
                "TVSeasonDetailsFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
