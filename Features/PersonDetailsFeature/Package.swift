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
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornPeople"),
        .package(path: "../../Platform/Observability"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "PersonDetailsFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "PeopleApplication", package: "PopcornPeople"),
                "Observability",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "PersonDetailsFeatureTests",
            dependencies: ["PersonDetailsFeature"]
        )
    ]
)
