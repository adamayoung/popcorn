// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TVSeriesIntelligenceFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVSeriesIntelligenceFeature", targets: ["TVSeriesIntelligenceFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornIntelligence"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(path: "../../Platform/Observability"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "TVSeriesIntelligenceFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "IntelligenceApplication", package: "PopcornIntelligence"),
                .product(name: "IntelligenceDomain", package: "PopcornIntelligence"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                "Observability",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "TVSeriesIntelligenceFeatureTests",
            dependencies: [
                "TVSeriesIntelligenceFeature",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ]
        )
    ]
)
