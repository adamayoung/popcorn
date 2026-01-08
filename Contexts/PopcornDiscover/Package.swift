// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornDiscover",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "DiscoverComposition", targets: ["DiscoverComposition"]),
        .library(name: "DiscoverApplication", targets: ["DiscoverApplication"]),
        .library(name: "DiscoverDomain", targets: ["DiscoverDomain"]),
        .library(name: "DiscoverInfrastructure", targets: ["DiscoverInfrastructure"]),
        .library(name: "DiscoverUITesting", targets: ["DiscoverUITesting"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Observability"),
        .package(path: "../../Platform/DataPersistenceInfrastructure")
    ],

    targets: [
        .target(
            name: "DiscoverComposition",
            dependencies: [
                "DiscoverApplication",
                "DiscoverDomain",
                "DiscoverInfrastructure"
            ]
        ),

        .target(
            name: "DiscoverApplication",
            dependencies: [
                "DiscoverDomain",
                "CoreDomain",
                "Observability"
            ]
        ),
        .testTarget(
            name: "DiscoverApplicationTests",
            dependencies: [
                "DiscoverApplication",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        ),

        .target(
            name: "DiscoverDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "DiscoverDomainTests",
            dependencies: ["DiscoverDomain"]
        ),

        .target(
            name: "DiscoverInfrastructure",
            dependencies: [
                "DiscoverDomain",
                "DataPersistenceInfrastructure",
                "Observability"
            ]
        ),
        .testTarget(
            name: "DiscoverInfrastructureTests",
            dependencies: [
                "DiscoverInfrastructure",
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        ),

        .target(
            name: "DiscoverUITesting",
            dependencies: [
                "DiscoverComposition",
                "DiscoverApplication",
                "DiscoverDomain",
                "CoreDomain"
            ]
        )
    ]
)
