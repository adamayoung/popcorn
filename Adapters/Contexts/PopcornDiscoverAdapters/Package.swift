// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornDiscoverAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornDiscoverAdapters", targets: ["PopcornDiscoverAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornDiscover"),
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornTV"),
        .package(path: "../../../Contexts/PopcornGenres"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../PopcornMoviesAdapters"),
        .package(path: "../PopcornTVAdapters"),
        .package(path: "../PopcornGenresAdapters"),
        .package(path: "../PopcornConfigurationAdapters"),
        .package(path: "../../Platform/TMDbAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "PopcornDiscoverAdapters",
            dependencies: [
                .product(name: "DiscoverComposition", package: "PopcornDiscover"),
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "DiscoverDomain", package: "PopcornDiscover"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "MoviesDomain", package: "PopcornMovies"),
                .product(name: "TVApplication", package: "PopcornTV"),
                .product(name: "TVDomain", package: "PopcornTV"),
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "GenresDomain", package: "PopcornGenres"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "PopcornMoviesAdapters",
                "PopcornTVAdapters",
                "PopcornGenresAdapters",
                "PopcornConfigurationAdapters",
                "TMDbAdapters",
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
