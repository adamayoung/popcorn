//
//  AppServices.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import ConfigurationComposition
import CoreDomain
import DiscoverComposition
import FeatureAccess
import Foundation
import GamesCatalogComposition
import GenresComposition
import IntelligenceComposition
import MoviesComposition
import Observability
import PeopleComposition
import PlotRemixGameComposition
import PopcornTVListingsAdapters
import SearchComposition
import ThemeColorProvider
import TMDb
import TrendingComposition
import TVListingsComposition
import TVSeriesComposition

///
/// The app's composition root. Builds the shared service and factory graph exactly
/// once, in dependency order.
///
/// Per-feature `Dependencies.live(services:)` builders call these factories to obtain
/// use cases. The graph is acyclic and is constructed in `init` so that a unit test
/// can build it offline without touching the network. The construction itself lives in
/// `AppServices+Composition.swift`.
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
    public let tvListingsFactory: PopcornTVListingsFactory

    // MARK: - Platform services

    /// Feature-flag service used for reads. The same instance backs `featureFlagsInitialiser`
    /// and `featureFlagsOverride`.
    public let featureFlags: any FeatureFlagging

    /// Feature-flag override service used by the developer feature-flags screen. Same instance
    /// as `featureFlags` (single service, single lifetime).
    public let featureFlagsOverride: any FeatureFlagOverriding

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
    ///     Defaults to the pinned production URL.
    ///   - tmdbAPIKey: The TMDb API key passed to the `TMDbClient`. Defaults to the key
    ///     resolved from the app's configuration.
    ///
    public init(
        tvListingsEPGURL: URL = HTTPTVListingsRemoteDataSource.defaultEPGURL,
        tmdbAPIKey: String? = nil
    ) {
        let graph = Self.buildGraph(tvListingsEPGURL: tvListingsEPGURL, tmdbAPIKey: tmdbAPIKey)
        self.tmdbClient = graph.tmdbClient
        self.fetchAppConfiguration = graph.fetchAppConfiguration
        self.themeColorProvider = graph.themeColorProvider
        self.configurationFactory = graph.configurationFactory
        self.genresFactory = graph.genresFactory
        self.moviesFactory = graph.moviesFactory
        self.tvSeriesFactory = graph.tvSeriesFactory
        self.peopleFactory = graph.peopleFactory
        self.discoverFactory = graph.discoverFactory
        self.trendingFactory = graph.trendingFactory
        self.searchFactory = graph.searchFactory
        self.gamesCatalogFactory = graph.gamesCatalogFactory
        self.intelligenceFactory = graph.intelligenceFactory
        self.plotRemixGameFactory = graph.plotRemixGameFactory
        self.tvListingsFactory = graph.tvListingsFactory
        // Feature-flag and observability services are single instances backing both
        // the read and the initialiser surface (single service, single lifetime).
        self.featureFlags = graph.featureFlagService
        self.featureFlagsOverride = graph.featureFlagService
        self.featureFlagsInitialiser = graph.featureFlagService
        self.observability = graph.observabilityService
        self.observabilityInitialiser = graph.observabilityService
    }

    /// The fully constructed service and factory graph, built once in dependency order
    /// by `buildGraph(tvListingsEPGURL:tmdbAPIKey:)`.
    struct Graph {
        let tmdbClient: TMDbClient
        let fetchAppConfiguration: any FetchAppConfigurationUseCase
        let themeColorProvider: (any ThemeColorProviding)?
        let configurationFactory: PopcornConfigurationFactory
        let genresFactory: PopcornGenresFactory
        let moviesFactory: PopcornMoviesFactory
        let tvSeriesFactory: PopcornTVSeriesFactory
        let peopleFactory: PopcornPeopleFactory
        let discoverFactory: PopcornDiscoverFactory
        let trendingFactory: PopcornTrendingFactory
        let searchFactory: PopcornSearchFactory
        let gamesCatalogFactory: PopcornGamesCatalogFactory
        let intelligenceFactory: PopcornIntelligenceFactory
        let plotRemixGameFactory: PopcornPlotRemixGameFactory
        let tvListingsFactory: PopcornTVListingsFactory
        let featureFlagService: any FeatureFlagging & FeatureFlagOverriding & FeatureFlagInitialising
        let observabilityService: any Observing & ObservabilityInitialising
    }

}
