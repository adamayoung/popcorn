// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoviesKitAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "MoviesKitAdapters", targets: ["MoviesKitAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Kits/MoviesKit"),
        .package(path: "../../../Kits/ConfigurationKit"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../ConfigurationKitAdapters"),
        .package(path: "../../Platform/TMDbAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "MoviesKitAdapters",
            dependencies: [
                .product(name: "MoviesApplication", package: "MoviesKit"),
                .product(name: "MoviesDomain", package: "MoviesKit"),
                .product(name: "MoviesInfrastructure", package: "MoviesKit"),
                .product(name: "ConfigurationApplication", package: "ConfigurationKit"),
                "CoreDomain",
                "ConfigurationKitAdapters",
                "TMDbAdapters",
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
