// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornPeopleAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PopcornPeopleAdapters", targets: ["PopcornPeopleAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Contexts/PopcornPeople"),
        .package(path: "../../../Contexts/PopcornConfiguration"),
        .package(path: "../../../Core/CoreDomain"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0")
    ],

    targets: [
        .target(
            name: "PopcornPeopleAdapters",
            dependencies: [
                .product(name: "PeopleComposition", package: "PopcornPeople"),
                .product(name: "PeopleDomain", package: "PopcornPeople"),
                .product(name: "PeopleInfrastructure", package: "PopcornPeople"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                "CoreDomain",
                "TMDb"
            ]
        ),
        .testTarget(
            name: "PopcornPeopleAdaptersTests",
            dependencies: ["PopcornPeopleAdapters"]
        )
    ]
)
