// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TVSeasonDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVSeasonDetailsFeature", targets: ["TVSeasonDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/TCAFoundation"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(path: "../../Platform/Observability"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "TVSeasonDetailsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "TCAFoundation",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                "Observability",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TVSeasonDetailsFeatureTests",
            dependencies: ["TVSeasonDetailsFeature"]
        )
    ]
)
