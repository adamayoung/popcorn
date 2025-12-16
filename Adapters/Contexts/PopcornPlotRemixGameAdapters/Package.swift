// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornPlotRemixGameAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornPlotRemixGameAdapters", targets: ["PopcornPlotRemixGameAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornPlotRemixGame"),
        .package(path: "../../../Contexts/PopcornDiscover"),
        .package(path: "../../../Contexts/PopcornGenres"),
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../PopcornDiscoverAdapters"),
        .package(path: "../PopcornMoviesAdapters"),
        .package(path: "../PopcornGenresAdapters"),
        .package(path: "../PopcornConfigurationAdapters"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "PopcornPlotRemixGameAdapters",
            dependencies: [
                .product(name: "PlotRemixGameComposition", package: "PopcornPlotRemixGame"),
                .product(name: "PlotRemixGameApplication", package: "PopcornPlotRemixGame"),
                .product(name: "PlotRemixGameDomain", package: "PopcornPlotRemixGame"),
                .product(name: "PlotRemixGameInfrastructure", package: "PopcornPlotRemixGame"),
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "DiscoverDomain", package: "PopcornDiscover"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "MoviesDomain", package: "PopcornMovies"),
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "GenresDomain", package: "PopcornGenres"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "PopcornDiscoverAdapters",
                "PopcornMoviesAdapters",
                "PopcornGenresAdapters",
                "PopcornConfigurationAdapters",
                "TMDb"
            ]
        )
    ]
)
