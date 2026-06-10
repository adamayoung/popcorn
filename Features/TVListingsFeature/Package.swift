// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TVListingsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "TVListingsFeature", targets: ["TVListingsFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornTVListings")
    ],

    targets: [
        .target(
            name: "TVListingsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "Presentation",
                .product(name: "TVListingsApplication", package: "PopcornTVListings"),
                .product(name: "TVListingsDomain", package: "PopcornTVListings")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TVListingsFeatureTests",
            dependencies: [
                "TVListingsFeature",
                .product(name: "TVListingsDomain", package: "PopcornTVListings")
            ]
        )
    ]
)
