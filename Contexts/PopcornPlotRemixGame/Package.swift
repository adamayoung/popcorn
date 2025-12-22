// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornPlotRemixGame",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PlotRemixGameComposition", targets: ["PlotRemixGameComposition"]),
        .library(name: "PlotRemixGameApplication", targets: ["PlotRemixGameApplication"]),
        .library(name: "PlotRemixGameDomain", targets: ["PlotRemixGameDomain"]),
        .library(name: "PlotRemixGameInfrastructure", targets: ["PlotRemixGameInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Observability")
    ],

    targets: [
        .target(
            name: "PlotRemixGameComposition",
            dependencies: [
                "PlotRemixGameApplication",
                "PlotRemixGameDomain",
                "PlotRemixGameInfrastructure"
            ]
        ),

        .target(
            name: "PlotRemixGameApplication",
            dependencies: [
                "PlotRemixGameDomain",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "PlotRemixGameApplicationTests",
            dependencies: ["PlotRemixGameApplication"]
        ),

        .target(
            name: "PlotRemixGameDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "PlotRemixGameDomainTests",
            dependencies: [
                "PlotRemixGameDomain"
            ]
        ),

        .target(
            name: "PlotRemixGameInfrastructure",
            dependencies: [
                "PlotRemixGameDomain",
                "Observability"
            ]
        ),
        .testTarget(
            name: "PlotRemixGameInfrastructureTests",
            dependencies: [
                "PlotRemixGameInfrastructure",
                "PlotRemixGameDomain",
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        )
    ]
)
