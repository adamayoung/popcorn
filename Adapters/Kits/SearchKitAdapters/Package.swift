// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SearchKitAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "SearchKitAdapters", targets: ["SearchKitAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Kits/SearchKit"),
        .package(path: "../../../Kits/ConfigurationKit"),
        .package(path: "../../../Kits/MoviesKit"),
        .package(path: "../../../Kits/TVKit"),
        .package(path: "../../../Kits/PeopleKit"),
        .package(path: "../../../Core/CoreDomain"),
        .package(path: "../ConfigurationKitAdapters"),
        .package(path: "../MoviesKitAdapters"),
        .package(path: "../TVKitAdapters"),
        .package(path: "../PeopleKitAdapters"),
        .package(path: "../../../Platform/TMDbAdapters"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "SearchKitAdapters",
            dependencies: [
                .product(name: "SearchApplication", package: "SearchKit"),
                .product(name: "ConfigurationApplication", package: "ConfigurationKit"),
                .product(name: "MoviesApplication", package: "MoviesKit"),
                .product(name: "TVApplication", package: "TVKit"),
                .product(name: "PeopleApplication", package: "PeopleKit"),
                "CoreDomain",
                "ConfigurationKitAdapters",
                "MoviesKitAdapters",
                "TVKitAdapters",
                "PeopleKitAdapters",
                "TMDbAdapters",
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
