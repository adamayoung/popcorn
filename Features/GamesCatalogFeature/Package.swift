// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GamesCatalogFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "GamesCatalogFeature", targets: ["GamesCatalogFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Contexts/PopcornGamesCatalog"),
        .package(path: "../../Core/DesignSystem"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "GamesCatalogFeature",
            dependencies: [
                "AppDependencies",
                .product(name: "GamesCatalogApplication", package: "PopcornGamesCatalog"),
                .product(name: "GamesCatalogDomain", package: "PopcornGamesCatalog"),
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "GamesCatalogFeatureTests",
            dependencies: ["GamesCatalogFeature"]
        )
    ]
)
