//
//  ExploreDependencies.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import DiscoverApplication
import Foundation
import MoviesApplication
import Observability
import TrendingApplication

/// The dependencies required by ``ExploreViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``ExploreViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. Build the production instance with ``live(services:)``.
public struct ExploreDependencies: Sendable {

    public var fetchDiscoverMovies: @Sendable () async throws -> [MoviePreview]
    public var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]
    public var fetchPopularMovies: @Sendable () async throws -> [MoviePreview]
    public var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]
    public var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

    public var isDiscoverMoviesEnabled: @Sendable () throws -> Bool
    public var isTrendingMoviesEnabled: @Sendable () throws -> Bool
    public var isPopularMoviesEnabled: @Sendable () throws -> Bool
    public var isTrendingTVSeriesEnabled: @Sendable () throws -> Bool
    public var isTrendingPeopleEnabled: @Sendable () throws -> Bool

    public init(
        fetchDiscoverMovies: @escaping @Sendable () async throws -> [MoviePreview],
        fetchTrendingMovies: @escaping @Sendable () async throws -> [MoviePreview],
        fetchPopularMovies: @escaping @Sendable () async throws -> [MoviePreview],
        fetchTrendingTVSeries: @escaping @Sendable () async throws -> [TVSeriesPreview],
        fetchTrendingPeople: @escaping @Sendable () async throws -> [PersonPreview],
        isDiscoverMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isTrendingMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isPopularMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isTrendingTVSeriesEnabled: @escaping @Sendable () throws -> Bool,
        isTrendingPeopleEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchDiscoverMovies = fetchDiscoverMovies
        self.fetchTrendingMovies = fetchTrendingMovies
        self.fetchPopularMovies = fetchPopularMovies
        self.fetchTrendingTVSeries = fetchTrendingTVSeries
        self.fetchTrendingPeople = fetchTrendingPeople
        self.isDiscoverMoviesEnabled = isDiscoverMoviesEnabled
        self.isTrendingMoviesEnabled = isTrendingMoviesEnabled
        self.isPopularMoviesEnabled = isPopularMoviesEnabled
        self.isTrendingTVSeriesEnabled = isTrendingTVSeriesEnabled
        self.isTrendingPeopleEnabled = isTrendingPeopleEnabled
    }

}

public extension ExploreDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> ExploreDependencies {
        let fetchDiscoverMovies = services.discoverFactory.makeFetchDiscoverMoviesUseCase()
        let fetchTrendingMovies = services.trendingFactory.makeFetchTrendingMoviesUseCase()
        let fetchPopularMovies = services.moviesFactory.makeFetchPopularMoviesUseCase()
        let fetchTrendingTVSeries = services.trendingFactory.makeFetchTrendingTVSeriesUseCase()
        let fetchTrendingPeople = services.trendingFactory.makeFetchTrendingPeopleUseCase()
        let featureFlags = services.featureFlags

        return ExploreDependencies(
            fetchDiscoverMovies: {
                try await mapping("ExploreClient.fetchDiscoverMovies") {
                    try await fetchDiscoverMovies.execute().map { MoviePreviewMapper().map($0) }
                }
            },
            fetchTrendingMovies: {
                try await mapping("ExploreClient.fetchTrendingMovies") {
                    try await fetchTrendingMovies.execute().map { MoviePreviewMapper().map($0) }
                }
            },
            fetchPopularMovies: {
                try await mapping("ExploreClient.fetchPopularMovies") {
                    try await fetchPopularMovies.execute().map { MoviePreviewMapper().map($0) }
                }
            },
            fetchTrendingTVSeries: {
                try await mapping("ExploreClient.fetchTrendingTVSeries") {
                    try await fetchTrendingTVSeries.execute().map { TVSeriesPreviewMapper().map($0) }
                }
            },
            fetchTrendingPeople: {
                try await mapping("ExploreClient.fetchTrendingPeople") {
                    try await fetchTrendingPeople.execute().map { PersonPreviewMapper().map($0) }
                }
            },
            isDiscoverMoviesEnabled: { featureFlags.isEnabled(.exploreDiscoverMovies) },
            isTrendingMoviesEnabled: { featureFlags.isEnabled(.exploreTrendingMovies) },
            isPopularMoviesEnabled: { featureFlags.isEnabled(.explorePopularMovies) },
            isTrendingTVSeriesEnabled: { featureFlags.isEnabled(.exploreTrendingTVSeries) },
            isTrendingPeopleEnabled: { featureFlags.isEnabled(.exploreTrendingPeople) }
        )
    }

    /// Runs a content-fetch body inside a `clientFetch` observability span,
    /// translating any thrown error into a ``FetchExploreContentError``.
    private static func mapping<T: Sendable>(
        _ description: String,
        _ body: @Sendable () async throws -> T
    ) async throws -> T {
        let span = SpanContext.startChild(operation: .clientFetch, description: description)
        do {
            let result = try await body()
            span?.finish()
            return result
        } catch {
            span?.setData(error: error)
            span?.finish(status: .internalError)
            throw FetchExploreContentError(error)
        }
    }

}

#if DEBUG
    public extension ExploreDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: ExploreDependencies {
            ExploreDependencies(
                fetchDiscoverMovies: {
                    MoviePreview.mocks
                },
                fetchTrendingMovies: {
                    MoviePreview.mocks
                },
                fetchPopularMovies: {
                    MoviePreview.mocks
                },
                fetchTrendingTVSeries: {
                    TVSeriesPreview.mocks
                },
                fetchTrendingPeople: {
                    PersonPreview.mocks
                },
                isDiscoverMoviesEnabled: {
                    true
                },
                isTrendingMoviesEnabled: {
                    true
                },
                isPopularMoviesEnabled: {
                    true
                },
                isTrendingTVSeriesEnabled: {
                    true
                },
                isTrendingPeopleEnabled: {
                    true
                }
            )
        }

    }
#endif
