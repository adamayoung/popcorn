// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornGamesCatalogAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornGamesCatalogAdapters", targets: ["PopcornGamesCatalogAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornGamesCatalog"),
        .package(path: "../../../Platform/FeatureAccess")
    ],

    targets: [
        .target(
            name: "PopcornGamesCatalogAdapters",
            dependencies: [
                .product(name: "GamesCatalogComposition", package: "PopcornGamesCatalog"),
                "FeatureAccess"
            ]
        ),
        .testTarget(
            name: "PopcornGamesCatalogAdaptersTests",
            dependencies: ["PopcornGamesCatalogAdapters"]
        )
    ]
)
