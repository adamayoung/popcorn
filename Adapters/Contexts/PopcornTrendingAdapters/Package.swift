// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornTrendingAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornTrendingAdapters", targets: ["PopcornTrendingAdapters"]),
        .library(name: "PopcornTrendingAdaptersUITesting", targets: ["PopcornTrendingAdaptersUITesting"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornTrending"),
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornTVSeries"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "16.0.0")
    ],

    targets: [
        .target(
            name: "PopcornTrendingAdapters",
            dependencies: [
                .product(name: "TrendingComposition", package: "PopcornTrending"),
                .product(name: "TrendingDomain", package: "PopcornTrending"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "TMDb"
            ]
        ),

        .target(
            name: "PopcornTrendingAdaptersUITesting",
            dependencies: [
                .product(name: "TrendingComposition", package: "PopcornTrending"),
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "TrendingDomain", package: "PopcornTrending"),
                "CoreDomain"
            ]
        ),

        .testTarget(
            name: "PopcornTrendingAdaptersTests",
            dependencies: [
                "PopcornTrendingAdapters",
                .product(name: "TrendingDomain", package: "PopcornTrending"),
                .product(name: "TrendingInfrastructure", package: "PopcornTrending"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "TMDb"
            ]
        )
    ]
)
