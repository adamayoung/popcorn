// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornSearchAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornSearchAdapters", targets: ["PopcornSearchAdapters"]),
        .library(name: "PopcornSearchAdaptersUITesting", targets: ["PopcornSearchAdaptersUITesting"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornSearch"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornTVSeries"),
        .package(path: "../../../Contexts/PopcornPeople"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../PopcornMoviesAdapters"),
        .package(path: "../PopcornTVSeriesAdapters"),
        .package(path: "../PopcornPeopleAdapters"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "16.0.0")
    ],

    targets: [
        .target(
            name: "PopcornSearchAdapters",
            dependencies: [
                .product(name: "SearchComposition", package: "PopcornSearch"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "PeopleApplication", package: "PopcornPeople"),
                "CoreDomain",
                "PopcornMoviesAdapters",
                "PopcornTVSeriesAdapters",
                "PopcornPeopleAdapters",
                "TMDb"
            ]
        ),
        .testTarget(
            name: "PopcornSearchAdaptersTests",
            dependencies: [
                "PopcornSearchAdapters",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain")
            ]
        ),

        .target(
            name: "PopcornSearchAdaptersUITesting",
            dependencies: [
                .product(name: "SearchComposition", package: "PopcornSearch"),
                .product(name: "SearchApplication", package: "PopcornSearch"),
                .product(name: "SearchDomain", package: "PopcornSearch"),
                "CoreDomain"
            ]
        )
    ]
)
