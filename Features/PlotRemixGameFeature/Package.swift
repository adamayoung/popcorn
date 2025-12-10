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
        .package(path: "../../Contexts/PopcornGamesCatalog"),
        .package(path: "../../Adapters/Contexts/PopcornGamesCatalogAdapters"),
        .package(path: "../../Core/DesignSystem"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "PlotRemixGameFeature",
            dependencies: [
                .product(name: "GamesCatalogApplication", package: "PopcornGamesCatalog"),
                "PopcornGamesCatalogAdapters",
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "PlotRemixGameFeatureTests",
            dependencies: ["PlotRemixGameFeature"]
        )
    ]
)
