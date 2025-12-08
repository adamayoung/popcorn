// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataPersistenceInfrastructure",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "DataPersistenceInfrastructure", targets: ["DataPersistenceInfrastructure"])
    ],

    targets: [
        .target(name: "DataPersistenceInfrastructure"),
        .testTarget(
            name: "DataPersistenceInfrastructureTests",
            dependencies: ["DataPersistenceInfrastructure"]
        )
    ]
)
