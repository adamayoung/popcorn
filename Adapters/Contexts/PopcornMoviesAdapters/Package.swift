// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornMoviesAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornMoviesAdapters", targets: ["PopcornMoviesAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornMovies"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../../../Platform/Observability"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "16.0.0")
    ],

    targets: [
        .target(
            name: "PopcornMoviesAdapters",
            dependencies: [
                .product(name: "MoviesComposition", package: "PopcornMovies"),
                .product(name: "MoviesDomain", package: "PopcornMovies"),
                .product(name: "MoviesInfrastructure", package: "PopcornMovies"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "TMDb"
            ]
        ),
        .testTarget(
            name: "PopcornMoviesAdaptersTests",
            dependencies: [
                "PopcornMoviesAdapters",
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                .product(name: "MoviesDomain", package: "PopcornMovies"),
                .product(name: "MoviesInfrastructure", package: "PopcornMovies"),
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "ObservabilityTestHelpers", package: "Observability"),
                "TMDb"
            ]
        )
    ]
)
