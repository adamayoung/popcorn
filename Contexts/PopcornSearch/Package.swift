// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornSearch",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "SearchComposition", targets: ["SearchComposition"]),
        .library(name: "SearchApplication", targets: ["SearchApplication"]),
        .library(name: "SearchDomain", targets: ["SearchDomain"]),
        .library(name: "SearchInfrastructure", targets: ["SearchInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/DataPersistenceInfrastructure")
    ],

    targets: [
        .target(
            name: "SearchComposition",
            dependencies: [
                "SearchApplication",
                "SearchDomain",
                "SearchInfrastructure"
            ]
        ),

        .target(
            name: "SearchApplication",
            dependencies: [
                "SearchDomain",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "SearchApplicationTests",
            dependencies: [
                "SearchApplication",
                "SearchDomain",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain")
            ]
        ),

        .target(
            name: "SearchDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "SearchDomainTests",
            dependencies: ["SearchDomain"]
        ),

        .target(
            name: "SearchInfrastructure",
            dependencies: [
                "SearchDomain",
                "DataPersistenceInfrastructure"
            ]
        ),
        .testTarget(
            name: "SearchInfrastructureTests",
            dependencies: [
                "SearchInfrastructure",
                "SearchDomain"
            ]
        )
    ]
)
