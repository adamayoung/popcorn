// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornTVListings",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "TVListingsComposition", targets: ["TVListingsComposition"]),
        .library(name: "TVListingsApplication", targets: ["TVListingsApplication"]),
        .library(name: "TVListingsDomain", targets: ["TVListingsDomain"]),
        .library(name: "TVListingsInfrastructure", targets: ["TVListingsInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/DataPersistenceInfrastructure"),
        .package(path: "../../Platform/Observability")
    ],

    targets: [
        .target(
            name: "TVListingsComposition",
            dependencies: [
                "TVListingsApplication",
                "TVListingsDomain",
                "TVListingsInfrastructure"
            ]
        ),
        .testTarget(
            name: "TVListingsCompositionTests",
            dependencies: [
                "TVListingsComposition",
                "TVListingsDomain",
                "TVListingsInfrastructure"
            ]
        ),

        .target(
            name: "TVListingsApplication",
            dependencies: [
                "TVListingsDomain",
                "CoreDomain",
                "Observability"
            ]
        ),
        .testTarget(
            name: "TVListingsApplicationTests",
            dependencies: [
                "TVListingsApplication",
                "TVListingsDomain",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        ),

        .target(
            name: "TVListingsDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "TVListingsDomainTests",
            dependencies: [
                "TVListingsDomain"
            ]
        ),

        .target(
            name: "TVListingsInfrastructure",
            dependencies: [
                "TVListingsDomain",
                "DataPersistenceInfrastructure",
                "Observability"
            ]
        ),
        .testTarget(
            name: "TVListingsInfrastructureTests",
            dependencies: [
                "TVListingsInfrastructure",
                "TVListingsDomain",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        )
    ]
)
