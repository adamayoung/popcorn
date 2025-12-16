// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrendingPeopleFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TrendingPeopleFeature", targets: ["TrendingPeopleFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornTrending"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "TrendingPeopleFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "TrendingDomain", package: "PopcornTrending"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "TrendingPeopleFeatureTests",
            dependencies: ["TrendingPeopleFeature"]
        )
    ]
)
