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

    /// Builds the acyclic graph in strict dependency order.
    static func buildGraph(tvListingsEPGURL: URL, tmdbAPIKey: String?) -> Graph {
        let domain = buildDomain(tmdbAPIKey: tmdbAPIKey)

        // Platform services + the factories that depend on them.
        let featureFlagService = makeFeatureFlagService()
        let gamesCatalogAdapters = PopcornGamesCatalogAdaptersFactory(
            featureFlags: featureFlagService
        )
        let gamesCatalogFactory = PopcornGamesCatalogFactory(
            featureFlagProvider: gamesCatalogAdapters.makeFeatureFlagProvider()
        )
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
        let tvListingsAdapters = PopcornTVListingsAdaptersFactory(
            epgURL: tvListingsEPGURL
        )
        let tvListingsFactory = PopcornTVListingsFactory(
            remoteDataSource: tvListingsAdapters.makeRemoteDataSource()
        )

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

    // MARK: - Context builders

    private static func makeConfiguration(tmdb: TMDbClient) -> ConfigurationBundle {
        let adapters = PopcornConfigurationAdaptersFactory(
            configurationService: tmdb.configurations
        )
        let factory = PopcornConfigurationFactory(
            configurationRemoteDataSource: adapters.makeConfigurationRemoteDataSource()
        )
        return ConfigurationBundle(
            factory: factory,
            fetchAppConfiguration: factory.makeFetchAppConfigurationUseCase()
        )
    }

    private static func makeGenres(foundations: Foundations) -> GenresBundle {
        let adapters = PopcornGenresAdaptersFactory(
            genreService: foundations.tmdb.genres,
            discoverService: foundations.tmdb.discover,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration
        )
        let factory = PopcornGenresFactory(
            genreRemoteDataSource: adapters.makeGenreRemoteDataSource(),
            appConfigurationProvider: adapters.makeAppConfigurationProvider(),
            genreBackdropProvider: adapters.makeGenreBackdropProvider()
        )
        return GenresBundle(
            factory: factory,
            fetchMovieGenres: factory.makeFetchMovieGenresUseCase(),
            fetchTVSeriesGenres: factory.makeFetchTVSeriesGenresUseCase()
        )
    }

    private static func makeMovies(foundations: Foundations) -> MoviesBundle {
        let adapters = PopcornMoviesAdaptersFactory(
            movieService: foundations.tmdb.movies,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration
        )
        let factory = PopcornMoviesFactory(
            movieRemoteDataSource: adapters.makeMovieRemoteDataSource(),
            appConfigurationProvider: adapters.makeAppConfigurationProvider(),
            themeColorProvider: foundations.themeColorProvider
        )
        return MoviesBundle(
            factory: factory,
            fetchDetails: factory.makeFetchMovieDetailsUseCase(),
            fetchCredits: factory.makeFetchMovieCreditsUseCase(),
            fetchRecommendations: factory.makeFetchMovieRecommendationsUseCase(),
            fetchImageCollection: factory.makeFetchMovieImageCollectionUseCase()
        )
    }

    private static func makeTVSeries(foundations: Foundations) -> TVSeriesBundle {
        let adapters = PopcornTVSeriesAdaptersFactory(
            tvSeriesService: foundations.tmdb.tvSeries,
            tvSeasonService: foundations.tmdb.tvSeasons,
            tvEpisodeService: foundations.tmdb.tvEpisodes,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration
        )
        let factory = PopcornTVSeriesFactory(
            tvSeriesRemoteDataSource: adapters.makeTVSeriesRemoteDataSource(),
            tvSeasonRemoteDataSource: adapters.makeTVSeasonRemoteDataSource(),
            tvEpisodeRemoteDataSource: adapters.makeTVEpisodeRemoteDataSource(),
            appConfigurationProvider: adapters.makeAppConfigurationProvider(),
            themeColorProvider: foundations.themeColorProvider
        )
        return TVSeriesBundle(
            factory: factory,
            fetchDetails: factory.makeFetchTVSeriesDetailsUseCase(),
            fetchImageCollection: factory.makeFetchTVSeriesImageCollectionUseCase()
        )
    }

    private static func makePeople(foundations: Foundations) -> PeopleBundle {
        let adapters = PopcornPeopleAdaptersFactory(
            personService: foundations.tmdb.people,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration
        )
        let factory = PopcornPeopleFactory(
            personRemoteDataSource: adapters.makePersonRemoteDataSource(),
            appConfigurationProvider: adapters.makeAppConfigurationProvider()
        )
        return PeopleBundle(factory: factory, fetchDetails: factory.makeFetchPersonDetailsUseCase())
    }

    private static func makeDiscover(
        foundations: Foundations,
        genres: GenresBundle,
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle
    ) -> DiscoverBundle {
        let adapters = PopcornDiscoverAdaptersFactory(
            discoverService: foundations.tmdb.discover,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            fetchMovieGenresUseCase: genres.fetchMovieGenres,
            fetchTVSeriesGenresUseCase: genres.fetchTVSeriesGenres,
            fetchMovieImageCollectionUseCase: movies.fetchImageCollection,
            fetchTVSeriesImageCollectionUseCase: tvSeries.fetchImageCollection
        )
        let factory = PopcornDiscoverFactory(
            discoverRemoteDataSource: adapters.makeDiscoverRemoteDataSource(),
            appConfigurationProvider: adapters.makeAppConfigurationProvider(),
            genreProvider: adapters.makeGenreProvider(),
            movieLogoImageProvider: adapters.makeMovieLogoImageProvider(),
            tvSeriesLogoImageProvider: adapters.makeTVSeriesLogoImageProvider(),
            themeColorProvider: foundations.themeColorProvider
        )
        return DiscoverBundle(factory: factory, fetchDiscoverMovies: factory.makeFetchDiscoverMoviesUseCase())
    }

    private static func makeTrendingFactory(
        foundations: Foundations,
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle
    ) -> PopcornTrendingFactory {
        let adapters = PopcornTrendingAdaptersFactory(
            trendingService: foundations.tmdb.trending,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: movies.fetchImageCollection,
            fetchTVSeriesImageCollectionUseCase: tvSeries.fetchImageCollection
        )
        return PopcornTrendingFactory(
            trendingRemoteDataSource: adapters.makeTrendingRemoteDataSource(),
            appConfigurationProvider: adapters.makeAppConfigurationProvider(),
            movieLogoImageProvider: adapters.makeMovieLogoImageProvider(),
            tvSeriesLogoImageProvider: adapters.makeTVSeriesLogoImageProvider(),
            themeColorProvider: foundations.themeColorProvider
        )
    }

    private static func makeSearchFactory(
        foundations: Foundations,
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle,
        people: PeopleBundle
    ) -> PopcornSearchFactory {
        let adapters = PopcornSearchAdaptersFactory(
            searchService: foundations.tmdb.search,
            fetchAppConfigurationUseCase: foundations.fetchAppConfiguration,
            fetchMovieDetailsUseCase: movies.fetchDetails,
            fetchTVSeriesDetailsUseCase: tvSeries.fetchDetails,
            fetchPersonDetailsUseCase: people.fetchDetails
        )
        return PopcornSearchFactory(
            mediaRemoteDataSource: adapters.makeMediaRemoteDataSource(),
            appConfigurationProvider: adapters.makeAppConfigurationProvider(),
            mediaProvider: adapters.makeMediaProvider(),
            themeColorProvider: foundations.themeColorProvider
        )
    }

    private static func makeIntelligenceFactory(
        movies: MoviesBundle,
        tvSeries: TVSeriesBundle
    ) -> PopcornIntelligenceFactory {
        let adapters = PopcornIntelligenceAdaptersFactory(
            fetchMovieDetailsUseCase: movies.fetchDetails,
            fetchTVSeriesDetailsUseCase: tvSeries.fetchDetails,
            fetchMovieCreditsUseCase: movies.fetchCredits
        )
        return PopcornIntelligenceFactory(
            movieProvider: adapters.makeMovieProvider(),
            tvSeriesProvider: adapters.makeTVSeriesProvider(),
            creditsProvider: adapters.makeCreditsProvider()
        )
    }

    private static func makePlotRemixGameFactory(
        fetchAppConfiguration: any FetchAppConfigurationUseCase,
        discover: DiscoverBundle,
        movies: MoviesBundle,
        genres: GenresBundle,
        observabilityService: any Observing & ObservabilityInitialising
    ) -> PopcornPlotRemixGameFactory {
        let adapters = PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: discover.fetchDiscoverMovies,
            fetchMovieRecommendationsUseCase: movies.fetchRecommendations,
            fetchMovieGenresUseCase: genres.fetchMovieGenres
        )
        return PopcornPlotRemixGameFactory(
            appConfigurationProvider: adapters.makeAppConfigurationProvider(),
            movieProvider: adapters.makeMovieProvider(),
            genreProvider: adapters.makeGenreProvider(),
            observability: observabilityService
        )
    }

}
