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
        .library(name: "PopcornDiscoverAdapters", targets: ["PopcornDiscoverAdapters"]),
        .library(name: "PopcornDiscoverAdaptersUITesting", targets: ["PopcornDiscoverAdaptersUITesting"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornDiscover"),
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornTVSeries"),
        .package(path: "../../../Contexts/PopcornGenres"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "15.0.0")
    ],

    targets: [
        .target(
            name: "PopcornDiscoverAdapters",
            dependencies: [
                .product(name: "DiscoverComposition", package: "PopcornDiscover"),
                .product(name: "DiscoverDomain", package: "PopcornDiscover"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "GenresDomain", package: "PopcornGenres"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "TMDb"
            ]
        ),
        .testTarget(
            name: "PopcornDiscoverAdaptersTests",
            dependencies: ["PopcornDiscoverAdapters"]
        ),

        .target(
            name: "PopcornDiscoverAdaptersUITesting",
            dependencies: [
                .product(name: "DiscoverComposition", package: "PopcornDiscover"),
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "DiscoverDomain", package: "PopcornDiscover"),
                "CoreDomain"
            ]
        )
    ]
)
