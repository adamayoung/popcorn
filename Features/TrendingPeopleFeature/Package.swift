// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrendingPeopleFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "TrendingPeopleFeature", targets: ["TrendingPeopleFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornTrending"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "TrendingPeopleFeature",
            dependencies: [
                "DesignSystem",
                .product(name: "TrendingApplication", package: "PopcornTrending")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TrendingPeopleFeatureTests",
            dependencies: [
                "TrendingPeopleFeature",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "TrendingApplication", package: "PopcornTrending")
            ]
        ),
        .testTarget(
            name: "TrendingPeopleFeatureSnapshotTests",
            dependencies: [
                "TrendingPeopleFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
