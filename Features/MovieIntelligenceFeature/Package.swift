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
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornIntelligence"),
        .package(path: "../../Platform/Observability"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "MovieIntelligenceFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
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
            dependencies: ["MovieIntelligenceFeature"]
        )
    ]
)
