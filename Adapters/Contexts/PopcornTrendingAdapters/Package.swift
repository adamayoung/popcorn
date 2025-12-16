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
        .library(name: "PopcornTrendingAdapters", targets: ["PopcornTrendingAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornTrending"),
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornTV"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../PopcornMoviesAdapters"),
        .package(path: "../PopcornTVAdapters"),
        .package(path: "../PopcornConfigurationAdapters"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "PopcornTrendingAdapters",
            dependencies: [
                .product(name: "TrendingComposition", package: "PopcornTrending"),
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "TrendingDomain", package: "PopcornTrending"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "MoviesDomain", package: "PopcornMovies"),
                .product(name: "TVApplication", package: "PopcornTV"),
                .product(name: "TVDomain", package: "PopcornTV"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "PopcornMoviesAdapters",
                "PopcornTVAdapters",
                "PopcornConfigurationAdapters",
                "TMDb"
            ]
        )
    ]
)
