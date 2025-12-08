// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornConfiguration",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "ConfigurationApplication", targets: ["ConfigurationApplication"]),
        .library(name: "ConfigurationDomain", targets: ["ConfigurationDomain"]),
        .library(name: "ConfigurationInfrastructure", targets: ["ConfigurationInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Caching")
    ],

    targets: [
        .target(
            name: "ConfigurationApplication",
            dependencies: [
                "ConfigurationDomain",
                "ConfigurationInfrastructure",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "ConfigurationApplicationTests",
            dependencies: ["ConfigurationApplication"]
        ),

        .target(
            name: "ConfigurationDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "ConfigurationDomainTests",
            dependencies: ["ConfigurationDomain"]
        ),

        .target(
            name: "ConfigurationInfrastructure",
            dependencies: [
                "ConfigurationDomain",
                "Caching"
            ]
        ),
        .testTarget(
            name: "ConfigurationInfrastructureTests",
            dependencies: ["ConfigurationInfrastructure"]
        )
    ]

)
