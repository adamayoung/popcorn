// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "MovieDetailsFeature", targets: ["MovieDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/TCAFoundation"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Platform/FeatureAccess"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "MovieDetailsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "TCAFoundation",
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "MovieDetailsFeatureTests",
            dependencies: [
                "MovieDetailsFeature",
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "MoviesDomain", package: "PopcornMovies"),
                .product(name: "FeatureAccessTestHelpers", package: "FeatureAccess")
            ]
        )
    ]
)
