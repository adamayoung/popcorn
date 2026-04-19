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
        .package(path: "../../Core/TCAFoundation"),
        .package(path: "../../Contexts/PopcornTVListings"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "TVListingsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "TCAFoundation",
                .product(name: "TVListingsApplication", package: "PopcornTVListings"),
                .product(name: "TVListingsDomain", package: "PopcornTVListings"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "TVListingsFeatureTests",
            dependencies: [
                "TVListingsFeature",
                .product(name: "TVListingsDomain", package: "PopcornTVListings"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
