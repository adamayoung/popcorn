// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornGamesCatalog",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "GamesCatalogComposition", targets: ["GamesCatalogComposition"]),
        .library(name: "GamesCatalogApplication", targets: ["GamesCatalogApplication"]),
        .library(name: "GamesCatalogDomain", targets: ["GamesCatalogDomain"]),
        .library(name: "GamesCatalogInfrastructure", targets: ["GamesCatalogInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/DataPersistenceInfrastructure")
    ],

    targets: [
        .target(
            name: "GamesCatalogComposition",
            dependencies: [
                "GamesCatalogApplication",
                "GamesCatalogDomain",
                "GamesCatalogInfrastructure"
            ]
        ),

        .target(
            name: "GamesCatalogApplication",
            dependencies: [
                "GamesCatalogDomain"
            ]
        ),
        .testTarget(
            name: "GamesCatalogApplicationTests",
            dependencies: ["GamesCatalogApplication"]
        ),

        .target(
            name: "GamesCatalogDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "GamesCatalogDomainTests",
            dependencies: ["GamesCatalogDomain"]
        ),

        .target(
            name: "GamesCatalogInfrastructure",
            dependencies: [
                "GamesCatalogDomain",
                "DataPersistenceInfrastructure"
            ]
        ),
        .testTarget(
            name: "GamesCatalogInfrastructureTests",
            dependencies: ["GamesCatalogInfrastructure"]
        )
    ]
)
