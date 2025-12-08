// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornConfigurationAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornConfigurationAdapters", targets: ["PopcornConfigurationAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../../Platform/TMDbAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "PopcornConfigurationAdapters",
            dependencies: [
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                .product(name: "ConfigurationDomain", package: "PopcornConfiguration"),
                .product(name: "ConfigurationInfrastructure", package: "PopcornConfiguration"),
                "CoreDomain",
                "TMDbAdapters",
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
