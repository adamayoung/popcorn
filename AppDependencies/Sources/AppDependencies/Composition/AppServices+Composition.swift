//
//  AppServices+Composition.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import Caching
import ConfigurationApplication
import ConfigurationComposition
import CoreDomain
import DiscoverApplication
import DiscoverComposition
import FeatureAccess
import FeatureAccessAdapters
import Foundation
import GamesCatalogComposition
import GenresApplication
import GenresComposition
import IntelligenceComposition
import MoviesApplication
import MoviesComposition
import Observability
import ObservabilityAdapters
import PeopleApplication
import PeopleComposition
import PlotRemixGameComposition
import PopcornConfigurationAdapters
import PopcornDiscoverAdapters
import PopcornGamesCatalogAdapters
import PopcornGenresAdapters
import PopcornIntelligenceAdapters
import PopcornMoviesAdapters
import PopcornPeopleAdapters
import PopcornPlotRemixGameAdapters
import PopcornSearchAdapters
import PopcornTrendingAdapters
import PopcornTVListingsAdapters
import PopcornTVSeriesAdapters
import SearchComposition
import ThemeColorProvider
import TMDb
import TrendingComposition
import TVListingsComposition
import TVSeriesApplication
import TVSeriesComposition

extension AppServices {

    // MARK: - Graph construction

    /// Builds the acyclic graph in strict dependency order, mirroring the `*+TCA.liveValue`s.
    static func buildGraph(tvListingsEPGURL: URL, tmdbAPIKey: String?) -> Graph {
        let domain = buildDomain(tmdbAPIKey: tmdbAPIKey)

        // Platform services + the factories that depend on them.
        let featureFlagService = makeFeatureFlagService()
        let gamesCatalogFactory = PopcornGamesCatalogAdaptersFactory(
            featureFlags: featureFlagService
        ).makeGamesCatalogFactory()
        let observabilityService = makeObservabilityService()
        let intelligenceFactory = makeIntelligenceFactory(
            movies: domain.movies,
            tvSeries: domain.tvSeries
        )
        let plotRemixGameFactory = makePlotRemixGameFactory(
            fetchAppConfiguration: domain.configuration.fetchAppConfiguration,
            discover: domain.discover,
            movies: domain.movies,
            genres: domain.genres,
            observabilityService: observabilityService
        )
        let tvListingsFactory = PopcornTVListingsAdaptersFactory(
            epgURL: tvListingsEPGURL
        ).makeTVListingsFactory()

        return Graph(
            tmdbClient: domain.tmdb,
            fetchAppConfiguration: domain.configuration.fetchAppConfiguration,
            themeColorProvider: domain.themeColorProvider,
            configurationFactory: domain.configuration.factory,
            genresFactory: domain.genres.factory,
            moviesFactory: domain.movies.factory,
            tvSeriesFactory: domain.tvSeries.factory,
            peopleFactory: domain.people.factory,
            discoverFactory: domain.discover.factory,
            trendingFactory: domain.trendingFactory,
            searchFactory: domain.searchFactory,
            gamesCatalogFactory: gamesCatalogFactory,
            intelligenceFactory: intelligenceFactory,
            plotRemixGameFactory: plotRemixGameFactory,
            tvListingsFactory: tvListingsFactory,
            featureFlagService: featureFlagService,
            observabilityService: observabilityService
        )
    }

    /// The TMDb client and domain context factories, with the use cases consumed downstream.
    private struct Domain {
        let tmdb: TMDbClient
        let themeColorProvider: (any ThemeColorProviding)?
        let configuration: ConfigurationBundle
        let genres: GenresBundle
        let movies: MoviesBundle
        let tvSeries: TVSeriesBundle
        let people: PeopleBundle
        let discover: DiscoverBundle
        let trendingFactory: PopcornTrendingFactory
        let searchFactory: PopcornSearchFactory
    }

    /// Builds the TMDb client and every domain context factory in dependency order.
    private static func buildDomain(tmdbAPIKey: String?) -> Domain {
        let tmdb = makeTMDbClient(tmdbAPIKey: tmdbAPIKey)
        let configuration = makeConfiguration(tmdb: tmdb)
        let foundations = Foundations(
            tmdb: tmdb,
            fetchAppConfiguration: configuration.fetchAppConfiguration,
            themeColorProvider: makeThemeColorProvider()
        )

        let genres = makeGenres(foundations: foundations)
        let movies = makeMovies(foundations: foundations)
        let tvSeries = makeTVSeries(foundations: foundations)
        let people = makePeople(foundations: foundations)
        let discover = makeDiscover(
            foundations: foundations,
            genres: genres,
            movies: movies,
            tvSeries: tvSeries
        )
        let aggregators = makeAggregatorFactories(
            foundations: foundations,
            movies: movies,
            tvSeries: tvSeries,
            people: people
        )

        return Domain(
            tmdb: tmdb,
            themeColorProvider: foundations.themeColorProvider,
            configuration: configuration,
            genres: genres,
            movies: movies,
            tvSeries: tvSeries,
            people: people,
            discover: discover,
            trendingFactory: aggregators.trending,
            searchFactory: aggregators.search
        )
    }

    /// Builds the trending and search factories, which both aggregate movie/TV-series use cases.
    private static func makeAggregatorFactories(
        foundations: Foundations,
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle,
        people: PeopleBundle
    ) -> (trending: PopcornTrendingFactory, search: PopcornSearchFactory) {
        let trending = makeTrendingFactory(
            foundations: foundations,
            movies: movies,
            tvSeries: tvSeries
        )
        let search = makeSearchFactory(
            foundations: foundations,
            movies: movies,
            tvSeries: tvSeries,
            people: people
        )
        return (trending, search)
    }

    // MARK: - Context bundles

    /// Shared inputs threaded into every domain context factory.
    private struct Foundations {
        let tmdb: TMDbClient
        let fetchAppConfiguration: any FetchAppConfigurationUseCase
        let themeColorProvider: (any ThemeColorProviding)?
    }

    private struct ConfigurationBundle {
        let factory: PopcornConfigurationFactory
        let fetchAppConfiguration: any FetchAppConfigurationUseCase
    }

    private struct GenresBundle {
        let factory: PopcornGenresFactory
        let fetchMovieGenres: any FetchMovieGenresUseCase
        let fetchTVSeriesGenres: any FetchTVSeriesGenresUseCase
    }

    private struct MoviesBundle {
        let factory: PopcornMoviesFactory
        let fetchDetails: any FetchMovieDetailsUseCase
        let fetchCredits: any FetchMovieCreditsUseCase
        let fetchRecommendations: any FetchMovieRecommendationsUseCase
        let fetchImageCollection: any FetchMovieImageCollectionUseCase
    }

    private struct TVSeriesBundle {
        let factory: PopcornTVSeriesFactory
        let fetchDetails: any FetchTVSeriesDetailsUseCase
        let fetchImageCollection: any FetchTVSeriesImageCollectionUseCase
    }

    private struct PeopleBundle {
        let factory: PopcornPeopleFactory
        let fetchDetails: any FetchPersonDetailsUseCase
    }

    private struct DiscoverBundle {
        let factory: PopcornDiscoverFactory
        let fetchDiscoverMovies: any FetchDiscoverMoviesUseCase
    }

    // MARK: - Context builders

    private static func makeConfiguration(tmdb: TMDbClient) -> ConfigurationBundle {
        let factory = PopcornConfigurationAdaptersFactory(
            configurationService: tmdb.configurations
        ).makeConfigurationFactory()
        return ConfigurationBundle(
            factory: factory,
            fetchAppConfiguration: factory.makeFetchAppConfigurationUseCase()
        )
    }

    private static func makeGenres(foundations: Foundations) -> GenresBundle {
        let factory = PopcornGenresAdaptersFactory(
            genreService: foundations.tmdb.genres,
            discoverService: foundations.tmdb.discover,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration
        ).makeGenresFactory()
        return GenresBundle(
            factory: factory,
            fetchMovieGenres: factory.makeFetchMovieGenresUseCase(),
            fetchTVSeriesGenres: factory.makeFetchTVSeriesGenresUseCase()
        )
    }

    private static func makeMovies(foundations: Foundations) -> MoviesBundle {
        let factory = PopcornMoviesAdaptersFactory(
            movieService: foundations.tmdb.movies,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            themeColorProvider: foundations.themeColorProvider
        ).makeMoviesFactory()
        return MoviesBundle(
            factory: factory,
            fetchDetails: factory.makeFetchMovieDetailsUseCase(),
            fetchCredits: factory.makeFetchMovieCreditsUseCase(),
            fetchRecommendations: factory.makeFetchMovieRecommendationsUseCase(),
            fetchImageCollection: factory.makeFetchMovieImageCollectionUseCase()
        )
    }

    private static func makeTVSeries(foundations: Foundations) -> TVSeriesBundle {
        let factory = PopcornTVSeriesAdaptersFactory(
            tvSeriesService: foundations.tmdb.tvSeries,
            tvSeasonService: foundations.tmdb.tvSeasons,
            tvEpisodeService: foundations.tmdb.tvEpisodes,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            themeColorProvider: foundations.themeColorProvider
        ).makeTVSeriesFactory()
        return TVSeriesBundle(
            factory: factory,
            fetchDetails: factory.makeFetchTVSeriesDetailsUseCase(),
            fetchImageCollection: factory.makeFetchTVSeriesImageCollectionUseCase()
        )
    }

    private static func makePeople(foundations: Foundations) -> PeopleBundle {
        let factory = PopcornPeopleAdaptersFactory(
            personService: foundations.tmdb.people,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration
        ).makePeopleFactory()
        return PeopleBundle(factory: factory, fetchDetails: factory.makeFetchPersonDetailsUseCase())
    }

    private static func makeDiscover(
        foundations: Foundations,
        genres: GenresBundle,
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle
    ) -> DiscoverBundle {
        let factory = PopcornDiscoverAdaptersFactory(
            discoverService: foundations.tmdb.discover,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            fetchMovieGenresUseCase: genres.fetchMovieGenres,
            fetchTVSeriesGenresUseCase: genres.fetchTVSeriesGenres,
            fetchMovieImageCollectionUseCase: movies.fetchImageCollection,
            fetchTVSeriesImageCollectionUseCase: tvSeries.fetchImageCollection,
            themeColorProvider: foundations.themeColorProvider
        ).makeDiscoverFactory()
        return DiscoverBundle(factory: factory, fetchDiscoverMovies: factory.makeFetchDiscoverMoviesUseCase())
    }

    private static func makeTrendingFactory(
        foundations: Foundations,
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle
    ) -> PopcornTrendingFactory {
        PopcornTrendingAdaptersFactory(
            trendingService: foundations.tmdb.trending,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: movies.fetchImageCollection,
            fetchTVSeriesImageCollectionUseCase: tvSeries.fetchImageCollection,
            themeColorProvider: foundations.themeColorProvider
        ).makeTrendingFactory()
    }

    private static func makeSearchFactory(
        foundations: Foundations,
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle,
        people: PeopleBundle
    ) -> PopcornSearchFactory {
        PopcornSearchAdaptersFactory(
            searchService: foundations.tmdb.search,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            fetchMovieDetailsUseCase: movies.fetchDetails,
            fetchTVSeriesDetailsUseCase: tvSeries.fetchDetails,
            fetchPersonDetailsUseCase: people.fetchDetails,
            themeColorProvider: foundations.themeColorProvider
        ).makeSearchFactory()
    }

    private static func makeIntelligenceFactory(
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle
    ) -> PopcornIntelligenceFactory {
        PopcornIntelligenceAdaptersFactory(
            fetchMovieDetailsUseCase: movies.fetchDetails,
            fetchTVSeriesDetailsUseCase: tvSeries.fetchDetails,
            fetchMovieCreditsUseCase: movies.fetchCredits
        ).makeIntelligenceFactory()
    }

    private static func makePlotRemixGameFactory(
        fetchAppConfiguration: any FetchAppConfigurationUseCase,
        discover: DiscoverBundle,
        movies: MoviesBundle,
        genres: GenresBundle,
        observabilityService: any Observing & ObservabilityInitialising
    ) -> PopcornPlotRemixGameFactory {
        PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: discover.fetchDiscoverMovies,
            fetchMovieRecommendationsUseCase: movies.fetchRecommendations,
            fetchMovieGenresUseCase: genres.fetchMovieGenres,
            observability: observabilityService
        ).makePlotRemixGameFactory()
    }

}
