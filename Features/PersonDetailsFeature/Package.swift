// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersonDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PersonDetailsFeature", targets: ["PersonDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornPeople"),
        .package(path: "../../Adapters/Contexts/PopcornPeopleAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "PersonDetailsFeature",
            dependencies: [
                "DesignSystem",
                .product(name: "PeopleApplication", package: "PopcornPeople"),
                "PopcornPeopleAdapters",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "PersonDetailsFeatureTests",
            dependencies: ["PersonDetailsFeature"]
        )
    ]
)
