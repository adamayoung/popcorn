// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrendingKitAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TrendingKitAdapters", targets: ["TrendingKitAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Kits/TrendingKit"),
        .package(path: "../../../Kits/MoviesKit"),
        .package(path: "../../../Kits/TVKit"),
        .package(path: "../../../Kits/ConfigurationKit"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../MoviesKitAdapters"),
        .package(path: "../TVKitAdapters"),
        .package(path: "../ConfigurationKitAdapters"),
        .package(path: "../../Platform/TMDbAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "TrendingKitAdapters",
            dependencies: [
                .product(name: "TrendingApplication", package: "TrendingKit"),
                .product(name: "TrendingDomain", package: "TrendingKit"),
                .product(name: "MoviesApplication", package: "MoviesKit"),
                .product(name: "MoviesDomain", package: "MoviesKit"),
                .product(name: "TVApplication", package: "TVKit"),
                .product(name: "TVDomain", package: "TVKit"),
                .product(name: "ConfigurationApplication", package: "ConfigurationKit"),
                "CoreDomain",
                "MoviesKitAdapters",
                "TVKitAdapters",
                "ConfigurationKitAdapters",
                "TMDbAdapters",
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
