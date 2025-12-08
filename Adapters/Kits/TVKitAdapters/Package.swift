// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TVKitAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVKitAdapters", targets: ["TVKitAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Kits/TVKit"),
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
            name: "TVKitAdapters",
            dependencies: [
                .product(name: "TVApplication", package: "TVKit"),
                .product(name: "TVDomain", package: "TVKit"),
                .product(name: "TVInfrastructure", package: "TVKit"),
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
