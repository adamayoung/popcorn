// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureFlagsAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "FeatureFlagsAdapters", targets: ["FeatureFlagsAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Platform/FeatureFlags"),
        .package(url: "https://github.com/statsig-io/statsig-kit.git", from: "1.55.1"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "FeatureFlagsAdapters",
            dependencies: [
                "FeatureFlags",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Statsig", package: "statsig-kit")
            ]
        )
    ]
)
