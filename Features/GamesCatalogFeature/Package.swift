// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GamesCatalogFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "GamesCatalogFeature", targets: ["GamesCatalogFeature"])
    ],

    dependencies: [
        .package(path: "../../Contexts/PopcornGamesCatalog"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "GamesCatalogFeature",
            dependencies: [
                .product(name: "GamesCatalogApplication", package: "PopcornGamesCatalog"),
                .product(name: "GamesCatalogDomain", package: "PopcornGamesCatalog"),
                "DesignSystem",
                "Presentation"
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "GamesCatalogFeatureTests",
            dependencies: [
                "GamesCatalogFeature",
                "Presentation"
            ],
            path: "Tests/GamesCatalogueFeatureTests"
        ),
        .testTarget(
            name: "GamesCatalogFeatureSnapshotTests",
            dependencies: [
                "GamesCatalogFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
