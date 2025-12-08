// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConfigurationKitAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "ConfigurationKitAdapters", targets: ["ConfigurationKitAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Kits/ConfigurationKit"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../../Platform/TMDbAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "ConfigurationKitAdapters",
            dependencies: [
                .product(name: "ConfigurationApplication", package: "ConfigurationKit"),
                .product(name: "ConfigurationDomain", package: "ConfigurationKit"),
                .product(name: "ConfigurationInfrastructure", package: "ConfigurationKit"),
                "CoreDomain",
                "TMDbAdapters",
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
