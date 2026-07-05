// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieCastAndCrewFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "MovieCastAndCrewFeature", targets: ["MovieCastAndCrewFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Platform/Observability"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "MovieCastAndCrewFeature",
            dependencies: [
                "DesignSystem",
                "Presentation",
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                "Observability"
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "MovieCastAndCrewFeatureTests",
            dependencies: [
                "MovieCastAndCrewFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "MoviesApplication", package: "PopcornMovies")
            ]
        ),
        .testTarget(
            name: "MovieCastAndCrewFeatureSnapshotTests",
            dependencies: [
                "MovieCastAndCrewFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
