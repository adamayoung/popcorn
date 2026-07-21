//
//  ExploreDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import DiscoverApplication
import DiscoverComposition
import ExploreFeature
import FeatureAccess
import MoviesApplication
import MoviesComposition
import Observability
import TrendingApplication
import TrendingComposition

extension ExploreDependencies {

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
                    try await fetchTrendingMovies.execute().movies.map { MoviePreviewMapper().map($0) }
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
