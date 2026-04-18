// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornTVListingsAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "PopcornTVListingsAdapters", targets: ["PopcornTVListingsAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornTVListings"),
        .package(path: "../../../Platform/Observability")
    ],

    targets: [
        .target(
            name: "PopcornTVListingsAdapters",
            dependencies: [
                .product(name: "TVListingsComposition", package: "PopcornTVListings"),
                .product(name: "TVListingsDomain", package: "PopcornTVListings"),
                .product(name: "TVListingsInfrastructure", package: "PopcornTVListings"),
                "Observability"
            ]
        ),
        .testTarget(
            name: "PopcornTVListingsAdaptersTests",
            dependencies: [
                "PopcornTVListingsAdapters",
                .product(name: "TVListingsDomain", package: "PopcornTVListings"),
                .product(name: "TVListingsInfrastructure", package: "PopcornTVListings"),
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ],
            resources: [
                .process("Fixtures")
            ]
        )
    ]
)
