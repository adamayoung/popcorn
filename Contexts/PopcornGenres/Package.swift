// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornGenres",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "GenresApplication", targets: ["GenresApplication"]),
        .library(name: "GenresDomain", targets: ["GenresDomain"]),
        .library(name: "GenresInfrastructure", targets: ["GenresInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Caching")
    ],

    targets: [
        .target(
            name: "GenresApplication",
            dependencies: [
                "GenresDomain",
                "GenresInfrastructure",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "GenresApplicationTests",
            dependencies: ["GenresApplication"]
        ),

        .target(
            name: "GenresDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "GenresDomainTests",
            dependencies: ["GenresDomain"]
        ),

        .target(
            name: "GenresInfrastructure",
            dependencies: [
                "GenresDomain",
                "Caching"
            ]
        ),
        .testTarget(
            name: "GenresInfrastructureTests",
            dependencies: ["GenresInfrastructure"]
        )
    ]
)
