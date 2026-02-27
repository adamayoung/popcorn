// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieIntelligenceFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "MovieIntelligenceFeature", targets: ["MovieIntelligenceFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornMovies"),
        .package(path: "../../Contexts/PopcornIntelligence"),
        .package(path: "../../Platform/Observability"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        ),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "MovieIntelligenceFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "IntelligenceApplication", package: "PopcornIntelligence"),
                "Observability",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [
                .process("Assets.xcassets"),
                .process("Localizable.xcstrings")
            ]
        ),
        .testTarget(
            name: "MovieIntelligenceFeatureTests",
            dependencies: [
                "MovieIntelligenceFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "IntelligenceDomain", package: "PopcornIntelligence"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "MoviesDomain", package: "PopcornMovies"),
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        ),
        .testTarget(
            name: "MovieIntelligenceFeatureSnapshotTests",
            dependencies: [
                "MovieIntelligenceFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "SnapshotTestHelpers"
            ]
        )
    ]
)
