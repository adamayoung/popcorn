// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TVSeriesDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVSeriesDetailsFeature", targets: ["TVSeriesDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "TVSeriesDetailsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "TVSeriesDomain", package: "PopcornTVSeries"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "TVSeriesDetailsFeatureTests",
            dependencies: ["TVSeriesDetailsFeature"]
        )
    ]
)
