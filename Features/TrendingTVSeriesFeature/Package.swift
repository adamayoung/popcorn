// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrendingTVSeriesFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TrendingTVSeriesFeature", targets: ["TrendingTVSeriesFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornTrending"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "TrendingTVSeriesFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TrendingTVSeriesFeatureTests",
            dependencies: [
                "TrendingTVSeriesFeature",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "TrendingApplication", package: "PopcornTrending")
            ]
        )
    ]
)
