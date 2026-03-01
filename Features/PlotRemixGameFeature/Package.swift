// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlotRemixGameFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PlotRemixGameFeature", targets: ["PlotRemixGameFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Contexts/PopcornGamesCatalog"),
        .package(path: "../../Contexts/PopcornPlotRemixGame"),
        .package(path: "../../Core/DesignSystem"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        ),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "PlotRemixGameFeature",
            dependencies: [
                "AppDependencies",
                .product(name: "GamesCatalogApplication", package: "PopcornGamesCatalog"),
                .product(name: "GamesCatalogDomain", package: "PopcornGamesCatalog"),
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "PlotRemixGameFeatureTests",
            dependencies: [
                "PlotRemixGameFeature",
                .product(name: "GamesCatalogDomain", package: "PopcornGamesCatalog"),
                .product(name: "PlotRemixGameDomain", package: "PopcornPlotRemixGame")
            ]
        ),
        .testTarget(
            name: "PlotRemixGameFeatureSnapshotTests",
            dependencies: [
                "PlotRemixGameFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "DesignSystem",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
