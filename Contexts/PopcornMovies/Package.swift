// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornMovies",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "MoviesApplication", targets: ["MoviesApplication"]),
        .library(name: "MoviesDomain", targets: ["MoviesDomain"]),
        .library(name: "MoviesInfrastructure", targets: ["MoviesInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/DataPersistenceInfrastructure"),
        .package(path: "../../Platform/Caching")
    ],

    targets: [
        .target(
            name: "MoviesApplication",
            dependencies: [
                "MoviesDomain",
                "MoviesInfrastructure",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "MoviesApplicationTests",
            dependencies: ["MoviesApplication"]
        ),

        .target(
            name: "MoviesDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "MoviesDomainTests",
            dependencies: ["MoviesDomain"]
        ),

        .target(
            name: "MoviesInfrastructure",
            dependencies: [
                "MoviesDomain",
                "DataPersistenceInfrastructure",
                "Caching"
            ]
        ),
        .testTarget(
            name: "MoviesInfrastructureTests",
            dependencies: ["MoviesInfrastructure"]
        )
    ]
)
