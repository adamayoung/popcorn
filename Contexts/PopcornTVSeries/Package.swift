// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornTVSeries",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVSeriesComposition", targets: ["TVSeriesComposition"]),
        .library(name: "TVSeriesApplication", targets: ["TVSeriesApplication"]),
        .library(name: "TVSeriesDomain", targets: ["TVSeriesDomain"]),
        .library(name: "TVSeriesInfrastructure", targets: ["TVSeriesInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Caching")
    ],

    targets: [
        .target(
            name: "TVSeriesComposition",
            dependencies: [
                "TVSeriesApplication",
                "TVSeriesDomain",
                "TVSeriesInfrastructure"
            ]
        ),

        .target(
            name: "TVSeriesApplication",
            dependencies: [
                "TVSeriesDomain",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "TVSeriesApplicationTests",
            dependencies: ["TVSeriesApplication"]
        ),

        .target(
            name: "TVSeriesDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "TVSeriesDomainTests",
            dependencies: [
                "TVSeriesDomain"
            ]
        ),

        .target(
            name: "TVSeriesInfrastructure",
            dependencies: [
                "TVSeriesDomain",
                "Caching"
            ]
        ),
        .testTarget(
            name: "TVSeriesInfrastructureTests",
            dependencies: [
                "TVSeriesInfrastructure"
            ]
        )
    ]
)
