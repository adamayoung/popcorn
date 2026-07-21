// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiscoverMoviesFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "DiscoverMoviesFeature", targets: ["DiscoverMoviesFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornDiscover"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "DiscoverMoviesFeature",
            dependencies: [
                "DesignSystem",
                "Presentation",
                .product(name: "DiscoverApplication", package: "PopcornDiscover")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "DiscoverMoviesFeatureTests",
            dependencies: [
                "DiscoverMoviesFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "DiscoverApplication", package: "PopcornDiscover")
            ]
        ),
        .testTarget(
            name: "DiscoverMoviesFeatureSnapshotTests",
            dependencies: [
                "DiscoverMoviesFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
