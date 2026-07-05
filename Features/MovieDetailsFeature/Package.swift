// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "MovieDetailsFeature", targets: ["MovieDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "MovieDetailsFeature",
            dependencies: [
                "DesignSystem",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "MovieDetailsFeatureTests",
            dependencies: [
                "MovieDetailsFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "MoviesDomain", package: "PopcornMovies")
            ]
        ),
        .testTarget(
            name: "MovieDetailsFeatureSnapshotTests",
            dependencies: [
                "MovieDetailsFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
