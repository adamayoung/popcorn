// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaSearchFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "MediaSearchFeature", targets: ["MediaSearchFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornGenres"),
        .package(path: "../../Contexts/PopcornSearch"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "MediaSearchFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "Presentation",
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "SearchApplication", package: "PopcornSearch")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "MediaSearchFeatureTests",
            dependencies: [
                "MediaSearchFeature",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "SearchApplication", package: "PopcornSearch")
            ]
        ),
        .testTarget(
            name: "MediaSearchFeatureSnapshotTests",
            dependencies: [
                "MediaSearchFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
