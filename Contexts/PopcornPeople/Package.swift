// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornPeople",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "PeopleComposition", targets: ["PeopleComposition"]),
        .library(name: "PeopleApplication", targets: ["PeopleApplication"]),
        .library(name: "PeopleDomain", targets: ["PeopleDomain"]),
        .library(name: "PeopleInfrastructure", targets: ["PeopleInfrastructure"]),
        .library(name: "PeopleUITesting", targets: ["PeopleUITesting"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Caching")
    ],

    targets: [
        .target(
            name: "PeopleComposition",
            dependencies: [
                "PeopleApplication",
                "PeopleDomain",
                "PeopleInfrastructure"
            ]
        ),

        .target(
            name: "PeopleApplication",
            dependencies: [
                "PeopleDomain",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "PeopleApplicationTests",
            dependencies: [
                "PeopleApplication",
                "PeopleDomain",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain")
            ]
        ),

        .target(
            name: "PeopleDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "PeopleDomainTests",
            dependencies: ["PeopleDomain"]
        ),

        .target(
            name: "PeopleInfrastructure",
            dependencies: [
                "PeopleDomain",
                "Caching"
            ]
        ),
        .testTarget(
            name: "PeopleInfrastructureTests",
            dependencies: [
                "PeopleInfrastructure",
                "PeopleDomain"
            ]
        ),

        .target(
            name: "PeopleUITesting",
            dependencies: [
                "PeopleComposition",
                "PeopleApplication",
                "PeopleDomain",
                "CoreDomain"
            ]
        )
    ]
)
