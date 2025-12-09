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
        .library(name: "PopcornGenresAdapters", targets: ["PopcornGenresAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornGenres"),
        .package(path: "../../Platform/TMDbAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "PopcornGenresAdapters",
            dependencies: [
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "GenresDomain", package: "PopcornGenres"),
                .product(name: "GenresInfrastructure", package: "PopcornGenres"),
                "TMDbAdapters",
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
