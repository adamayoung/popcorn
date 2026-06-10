// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TVEpisodeCastAndCrewFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "TVEpisodeCastAndCrewFeature", targets: ["TVEpisodeCastAndCrewFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornTVSeries")
    ],

    targets: [
        .target(
            name: "TVEpisodeCastAndCrewFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "Presentation",
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TVEpisodeCastAndCrewFeatureTests",
            dependencies: [
                "TVEpisodeCastAndCrewFeature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries")
            ]
        )
    ]
)
