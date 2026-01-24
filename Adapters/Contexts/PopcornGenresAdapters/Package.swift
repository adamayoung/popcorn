// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornGenresAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornGenresAdapters", targets: ["PopcornGenresAdapters"]),
        .library(name: "PopcornGenresAdaptersUITesting", targets: ["PopcornGenresAdaptersUITesting"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornGenres"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "15.0.0")
    ],

    targets: [
        .target(
            name: "PopcornGenresAdapters",
            dependencies: [
                .product(name: "GenresComposition", package: "PopcornGenres"),
                .product(name: "GenresDomain", package: "PopcornGenres"),
                .product(name: "GenresInfrastructure", package: "PopcornGenres"),
                "TMDb"
            ]
        ),
        .testTarget(
            name: "PopcornGenresAdaptersTests",
            dependencies: ["PopcornGenresAdapters"]
        ),

        .target(
            name: "PopcornGenresAdaptersUITesting",
            dependencies: [
                .product(name: "GenresComposition", package: "PopcornGenres"),
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "GenresDomain", package: "PopcornGenres")
            ]
        )
    ]
)
