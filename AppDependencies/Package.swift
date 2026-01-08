// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDependencies",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "AppDependencies", targets: ["AppDependencies"])
    ],

    dependencies: [
        // TCA
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        ),

        // Context Packages
        .package(path: "../Contexts/PopcornConfiguration"),
        .package(path: "../Contexts/PopcornDiscover"),
        .package(path: "../Contexts/PopcornGamesCatalog"),
        .package(path: "../Contexts/PopcornGenres"),
        .package(path: "../Contexts/PopcornIntelligence"),
        .package(path: "../Contexts/PopcornMovies"),
        .package(path: "../Contexts/PopcornPeople"),
        .package(path: "../Contexts/PopcornPlotRemixGame"),
        .package(path: "../Contexts/PopcornSearch"),
        .package(path: "../Contexts/PopcornTrending"),
        .package(path: "../Contexts/PopcornTVSeries"),

        // Platform Packages
        .package(path: "../Platform/FeatureAccess"),
        .package(path: "../Platform/Observability"),

        // Context Adapters
        .package(path: "../Adapters/Contexts/PopcornConfigurationAdapters"),
        .package(path: "../Adapters/Contexts/PopcornDiscoverAdapters"),
        .package(path: "../Adapters/Contexts/PopcornGamesCatalogAdapters"),
        .package(path: "../Adapters/Contexts/PopcornGenresAdapters"),
        .package(path: "../Adapters/Contexts/PopcornIntelligenceAdapters"),
        .package(path: "../Adapters/Contexts/PopcornMoviesAdapters"),
        .package(path: "../Adapters/Contexts/PopcornPeopleAdapters"),
        .package(path: "../Adapters/Contexts/PopcornPlotRemixGameAdapters"),
        .package(path: "../Adapters/Contexts/PopcornSearchAdapters"),
        .package(path: "../Adapters/Contexts/PopcornTrendingAdapters"),
        .package(path: "../Adapters/Contexts/PopcornTVSeriesAdapters"),

        // Platform Adapters
        .package(path: "../Adapters/Platform/FeatureAccessAdapters"),
        .package(path: "../Adapters/Platform/ObservabilityAdapters")
    ],

    targets: [
        .target(
            name: "AppDependencies",
            dependencies: [
                // TCA
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),

                // Context Composition & Application Layers
                .product(name: "ConfigurationComposition", package: "PopcornConfiguration"),
                .product(name: "ConfigurationApplication", package: "PopcornConfiguration"),
                .product(name: "ConfigurationUITesting", package: "PopcornConfiguration"),
                .product(name: "DiscoverComposition", package: "PopcornDiscover"),
                .product(name: "DiscoverApplication", package: "PopcornDiscover"),
                .product(name: "DiscoverUITesting", package: "PopcornDiscover"),
                .product(name: "GamesCatalogComposition", package: "PopcornGamesCatalog"),
                .product(name: "GamesCatalogApplication", package: "PopcornGamesCatalog"),
                .product(name: "GamesCatalogUITesting", package: "PopcornGamesCatalog"),
                .product(name: "GenresComposition", package: "PopcornGenres"),
                .product(name: "GenresApplication", package: "PopcornGenres"),
                .product(name: "GenresUITesting", package: "PopcornGenres"),
                .product(name: "IntelligenceApplication", package: "PopcornIntelligence"),
                .product(name: "IntelligenceComposition", package: "PopcornIntelligence"),
                .product(name: "IntelligenceUITesting", package: "PopcornIntelligence"),
                .product(name: "MoviesApplication", package: "PopcornMovies"),
                .product(name: "MoviesComposition", package: "PopcornMovies"),
                .product(name: "MoviesUITesting", package: "PopcornMovies"),
                .product(name: "PeopleComposition", package: "PopcornPeople"),
                .product(name: "PeopleApplication", package: "PopcornPeople"),
                .product(name: "PeopleUITesting", package: "PopcornPeople"),
                .product(name: "PlotRemixGameComposition", package: "PopcornPlotRemixGame"),
                .product(name: "PlotRemixGameApplication", package: "PopcornPlotRemixGame"),
                .product(name: "PlotRemixGameUITesting", package: "PopcornPlotRemixGame"),
                .product(name: "SearchComposition", package: "PopcornSearch"),
                .product(name: "SearchApplication", package: "PopcornSearch"),
                .product(name: "SearchUITesting", package: "PopcornSearch"),
                .product(name: "TrendingComposition", package: "PopcornTrending"),
                .product(name: "TrendingApplication", package: "PopcornTrending"),
                .product(name: "TrendingUITesting", package: "PopcornTrending"),
                .product(name: "TVSeriesComposition", package: "PopcornTVSeries"),
                .product(name: "TVSeriesApplication", package: "PopcornTVSeries"),
                .product(name: "TVSeriesUITesting", package: "PopcornTVSeries"),

                // Platform
                "FeatureAccess",
                "Observability",

                // Context Adapters
                "PopcornConfigurationAdapters",
                "PopcornDiscoverAdapters",
                "PopcornGamesCatalogAdapters",
                "PopcornGenresAdapters",
                "PopcornIntelligenceAdapters",
                "PopcornMoviesAdapters",
                "PopcornPeopleAdapters",
                "PopcornPlotRemixGameAdapters",
                "PopcornSearchAdapters",
                "PopcornTrendingAdapters",
                "PopcornTVSeriesAdapters",

                // Platform Adapters
                "FeatureAccessAdapters",
                "ObservabilityAdapters"
            ]
        )
    ]
)
