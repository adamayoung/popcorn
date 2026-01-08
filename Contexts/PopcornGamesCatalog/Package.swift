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

    dependencies: [],

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
            dependencies: [
                "GamesCatalogApplication",
                "GamesCatalogDomain"
            ]
        ),

        .target(
            name: "GamesCatalogDomain",
            dependencies: []
        ),
        .testTarget(
            name: "GamesCatalogDomainTests",
            dependencies: ["GamesCatalogDomain"]
        ),

        .target(
            name: "GamesCatalogInfrastructure",
            dependencies: [
                "GamesCatalogDomain"
            ]
        ),
        .testTarget(
            name: "GamesCatalogInfrastructureTests",
            dependencies: [
                "GamesCatalogInfrastructure",
                "GamesCatalogDomain"
            ]
        )
    ]
)
