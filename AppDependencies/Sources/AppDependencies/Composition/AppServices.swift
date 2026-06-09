//
//  AppServices.swift
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

///
/// A plain, TCA-free composition root that builds the app's shared service and factory
/// graph exactly once, in dependency order.
///
/// `AppServices` mirrors what the existing `*+TCA.swift` `liveValue`s build, but as plain
/// sequential construction with no swift-dependencies, `@Dependency`, or TCA involvement.
/// It is the foundation for the in-progress TCA→MVVM migration: per-feature
/// `Dependencies.live(services:)` builders call these factories to obtain use cases.
///
/// The graph is acyclic and is constructed in `init` so that a unit test can build it
/// offline without touching the network.
///
public final class AppServices: Sendable {

    // MARK: - TMDb

    /// The shared TMDb client. All TMDb service slices are derived from this instance.
    public let tmdbClient: TMDbClient

    // MARK: - Shared use cases / providers

    /// The shared app-configuration use case consumed by most context factories.
    public let fetchAppConfiguration: any FetchAppConfigurationUseCase

    /// The shared theme-color provider (disk cached). Built once and reused everywhere.
    public let themeColorProvider: (any ThemeColorProviding)?

    // MARK: - Context factories

    public let configurationFactory: PopcornConfigurationFactory
    public let genresFactory: PopcornGenresFactory
    public let moviesFactory: PopcornMoviesFactory
    public let tvSeriesFactory: PopcornTVSeriesFactory
    public let peopleFactory: PopcornPeopleFactory
    public let discoverFactory: PopcornDiscoverFactory
    public let trendingFactory: PopcornTrendingFactory
    public let searchFactory: PopcornSearchFactory
    public let gamesCatalogFactory: PopcornGamesCatalogFactory
    public let intelligenceFactory: PopcornIntelligenceFactory
    public let plotRemixGameFactory: PopcornPlotRemixGameFactory
    public let tvListingsFactory: any PopcornTVListingsFactory

    // MARK: - Platform services

    /// Feature-flag service used for reads. The same instance backs `featureFlagsInitialiser`.
    public let featureFlags: any FeatureFlagging

    /// Feature-flag initialiser. Same instance as `featureFlags` (single service, single lifetime).
    public let featureFlagsInitialiser: any FeatureFlagInitialising

    /// Observability service used for reporting. The same instance backs `observabilityInitialiser`.
    public let observability: any Observing

    /// Observability initialiser. Same instance as `observability` (single service, single lifetime).
    public let observabilityInitialiser: any ObservabilityInitialising

    ///
    /// Builds the shared service and factory graph in dependency order.
    ///
    /// - Parameters:
    ///   - tvListingsEPGURL: The EPG feed URL passed to the TV listings adapters factory.
    ///     Defaults to the same pinned URL used by `TVListingsEPGURL+TCA.liveValue`.
    ///   - tmdbAPIKey: The TMDb API key passed to the `TMDbClient`. Defaults to the same
    ///     resolution used by `TMDbClient+TCA.liveValue`.
    ///
    public init(
        tvListingsEPGURL: URL = HTTPTVListingsRemoteDataSource.defaultEPGURL,
        tmdbAPIKey: String? = nil
    ) {
        // 1. TMDb client (mirrors TMDbClient+TCA.liveValue exactly).
        let tmdb = TMDbClient(
            apiKey: tmdbAPIKey ?? TMDbAPIKeyProvider.apiKey(),
            configuration: .init(
                defaultLanguage: Locale.current.language.minimalIdentifier,
                defaultCountry: Locale.current.region?.identifier,
                retry: .default,
                cache: .default
            )
        )
        self.tmdbClient = tmdb

        // 2. TMDb service slices.
        let configurationService = tmdb.configurations
        let discoverService = tmdb.discover
        let genreService = tmdb.genres
        let movieService = tmdb.movies
        let personService = tmdb.people
        let searchService = tmdb.search
        let trendingService = tmdb.trending
        let tvSeriesService = tmdb.tvSeries
        let tvSeasonService = tmdb.tvSeasons
        let tvEpisodeService = tmdb.tvEpisodes

        // 3. Configuration factory + shared app-configuration use case.
        let configurationFactory = PopcornConfigurationAdaptersFactory(
            configurationService: configurationService
        ).makeConfigurationFactory()
        self.configurationFactory = configurationFactory

        let fetchAppConfiguration = configurationFactory.makeFetchAppConfigurationUseCase()
        self.fetchAppConfiguration = fetchAppConfiguration

        // 4. Theme color provider (built once, reused by all consumers).
        let themeColorProvider = Self.makeThemeColorProvider()
        self.themeColorProvider = themeColorProvider

        // 5. Genres factory + genre use cases (consumed by discover/trending/plot remix).
        let genresFactory = PopcornGenresAdaptersFactory(
            genreService: genreService,
            discoverService: discoverService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makeGenresFactory()
        self.genresFactory = genresFactory

        let fetchMovieGenres = genresFactory.makeFetchMovieGenresUseCase()
        let fetchTVSeriesGenres = genresFactory.makeFetchTVSeriesGenresUseCase()

        // 6. Movies factory + movie use cases consumed by other factories.
        let moviesFactory = PopcornMoviesAdaptersFactory(
            movieService: movieService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            themeColorProvider: themeColorProvider
        ).makeMoviesFactory()
        self.moviesFactory = moviesFactory

        let fetchMovieDetails = moviesFactory.makeFetchMovieDetailsUseCase()
        let fetchMovieCredits = moviesFactory.makeFetchMovieCreditsUseCase()
        let fetchMovieRecommendations = moviesFactory.makeFetchMovieRecommendationsUseCase()
        let fetchMovieImageCollection = moviesFactory.makeFetchMovieImageCollectionUseCase()

        // 7. TV series factory + TV series use cases consumed by other factories.
        let tvSeriesFactory = PopcornTVSeriesAdaptersFactory(
            tvSeriesService: tvSeriesService,
            tvSeasonService: tvSeasonService,
            tvEpisodeService: tvEpisodeService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            themeColorProvider: themeColorProvider
        ).makeTVSeriesFactory()
        self.tvSeriesFactory = tvSeriesFactory

        let fetchTVSeriesDetails = tvSeriesFactory.makeFetchTVSeriesDetailsUseCase()
        let fetchTVSeriesImageCollection = tvSeriesFactory.makeFetchTVSeriesImageCollectionUseCase()

        // 8. People factory + person use case consumed by search.
        let peopleFactory = PopcornPeopleAdaptersFactory(
            personService: personService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makePeopleFactory()
        self.peopleFactory = peopleFactory

        let fetchPersonDetails = peopleFactory.makeFetchPersonDetailsUseCase()

        // 9. Discover factory + discover-movies use case consumed by plot remix.
        let discoverFactory = PopcornDiscoverAdaptersFactory(
            discoverService: discoverService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieGenresUseCase: fetchMovieGenres,
            fetchTVSeriesGenresUseCase: fetchTVSeriesGenres,
            fetchMovieImageCollectionUseCase: fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollection,
            themeColorProvider: themeColorProvider
        ).makeDiscoverFactory()
        self.discoverFactory = discoverFactory

        let fetchDiscoverMovies = discoverFactory.makeFetchDiscoverMoviesUseCase()

        // 10. Trending factory.
        self.trendingFactory = PopcornTrendingAdaptersFactory(
            trendingService: trendingService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollection,
            themeColorProvider: themeColorProvider
        ).makeTrendingFactory()

        // 11. Search factory.
        self.searchFactory = PopcornSearchAdaptersFactory(
            searchService: searchService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieDetailsUseCase: fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: fetchTVSeriesDetails,
            fetchPersonDetailsUseCase: fetchPersonDetails,
            themeColorProvider: themeColorProvider
        ).makeSearchFactory()

        // 12. Platform: feature flags (built once, reused for reads + initialiser).
        let featureFlagsFactory = FeatureAccessAdaptersFactory().makeFeatureFlagsFactory()
        let featureFlagService = featureFlagsFactory.featureFlagService
        self.featureFlags = featureFlagService
        self.featureFlagsInitialiser = featureFlagService

        // 13. Games catalog factory (depends on feature flags).
        self.gamesCatalogFactory = PopcornGamesCatalogAdaptersFactory(
            featureFlags: featureFlagService
        ).makeGamesCatalogFactory()

        // 14. Platform: observability (built ONCE, reused for reporting + initialiser).
        let observabilityService = ObservabilityAdaptersFactory()
            .makeObservabilityFactory()
            .makeService()
        self.observability = observabilityService
        self.observabilityInitialiser = observabilityService

        // 15. Intelligence factory (depends on movie/TV-series use cases).
        self.intelligenceFactory = PopcornIntelligenceAdaptersFactory(
            fetchMovieDetailsUseCase: fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: fetchTVSeriesDetails,
            fetchMovieCreditsUseCase: fetchMovieCredits
        ).makeIntelligenceFactory()

        // 16. Plot remix game factory (depends on config, discover, movies, observability).
        self.plotRemixGameFactory = PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: fetchDiscoverMovies,
            fetchMovieRecommendationsUseCase: fetchMovieRecommendations,
            fetchMovieGenresUseCase: fetchMovieGenres,
            observability: observabilityService
        ).makePlotRemixGameFactory()

        // 17. TV listings factory (depends on the EPG URL).
        self.tvListingsFactory = PopcornTVListingsAdaptersFactory(
            epgURL: tvListingsEPGURL
        ).makeTVListingsFactory()
    }

    // MARK: - Helpers

    private static func makeThemeColorProvider() -> (any ThemeColorProviding)? {
        let cache = CachesFactory.makeDiskCache(subdirectory: "ThemeColors")
        return DefaultThemeColorProvider(cache: cache)
    }

}
