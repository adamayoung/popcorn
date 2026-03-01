// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TVEpisodeCastAndCrewFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVEpisodeCastAndCrewFeature", targets: ["TVEpisodeCastAndCrewFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/TCAFoundation"),
        .package(path: "../../Contexts/PopcornTVSeries"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "TVEpisodeCastAndCrewFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "TCAFoundation",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TVEpisodeCastAndCrewFeatureTests",
            dependencies: [
                "TVEpisodeCastAndCrewFeature",
                "TCAFoundation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
