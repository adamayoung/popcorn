//
//  AppServicesTests.swift
//  AppDependenciesTests
//
//  Copyright © 2026 Adam Young.
//

@testable import AppDependencies
import Testing

@Suite("AppServices")
struct AppServicesTests {

    @Test("init builds the service graph offline")
    func initBuildsGraph() {
        let services = AppServices(tmdbAPIKey: "test_tmdb_api_key")

        // The shared use case and providers are wired during init.
        _ = services.fetchAppConfiguration
        _ = services.themeColorProvider
        _ = services.tmdbClient
        _ = services.featureFlags
        _ = services.featureFlagsInitialiser
        _ = services.observability
        _ = services.observabilityInitialiser
    }

    @Test("all context factories are constructed")
    func allFactoriesConstructed() {
        let services = AppServices(tmdbAPIKey: "test_tmdb_api_key")

        _ = services.configurationFactory
        _ = services.genresFactory
        _ = services.moviesFactory
        _ = services.tvSeriesFactory
        _ = services.peopleFactory
        _ = services.discoverFactory
        _ = services.trendingFactory
        _ = services.searchFactory
        _ = services.gamesCatalogFactory
        _ = services.intelligenceFactory
        _ = services.plotRemixGameFactory
        _ = services.tvListingsFactory
    }

    @Test("movies factory vends use cases without crashing")
    func moviesFactoryVendsUseCases() {
        let services = AppServices(tmdbAPIKey: "test_tmdb_api_key")

        _ = services.moviesFactory.makeFetchMovieDetailsUseCase()
        _ = services.moviesFactory.makeFetchMovieCreditsUseCase()
        _ = services.moviesFactory.makeFetchMovieImageCollectionUseCase()
    }

    @Test("people factory vends use cases without crashing")
    func peopleFactoryVendsUseCases() {
        let services = AppServices(tmdbAPIKey: "test_tmdb_api_key")

        _ = services.peopleFactory.makeFetchPersonDetailsUseCase()
    }

    @Test("tv series factory vends use cases without crashing")
    func tvSeriesFactoryVendsUseCases() {
        let services = AppServices(tmdbAPIKey: "test_tmdb_api_key")

        _ = services.tvSeriesFactory.makeFetchTVSeriesDetailsUseCase()
        _ = services.tvSeriesFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

}
