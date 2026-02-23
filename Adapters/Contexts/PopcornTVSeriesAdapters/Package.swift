// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornTVSeriesAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornTVSeriesAdapters", targets: ["PopcornTVSeriesAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornTVSeries"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../../../Platform/Observability"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "16.0.0")
    ],

    targets: [
        .target(
            name: "PopcornTVSeriesAdapters",
            dependencies: [
                .product(name: "TVSeriesComposition", package: "PopcornTVSeries"),
                .product(name: "TVSeriesDomain", package: "PopcornTVSeries"),
                .product(name: "TVSeriesInfrastructure", package: "PopcornTVSeries"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "Observability",
                "TMDb"
            ]
        ),
        .testTarget(
            name: "PopcornTVSeriesAdaptersTests",
            dependencies: [
                "PopcornTVSeriesAdapters",
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                .product(name: "TVSeriesDomain", package: "PopcornTVSeries"),
                .product(name: "TVSeriesInfrastructure", package: "PopcornTVSeries"),
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "ObservabilityTestHelpers", package: "Observability"),
                "TMDb"
            ]
        )
    ]
)
