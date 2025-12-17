//
//  ExploreClient.swift
//  ExploreFeature
//
//  Created by Adam Young on 21/11/2025.
//

import AppDependencies
import ComposableArchitecture
import DiscoverApplication
import Foundation
import MoviesApplication
import Observability
import TrendingApplication

@DependencyClient
struct ExploreClient: Sendable {

    var fetchDiscoverMovies: @Sendable () async throws -> [MoviePreview]
    var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]
    var fetchPopularMovies: @Sendable () async throws -> [MoviePreview]
    var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]
    var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

    var isDiscoverMoviesEnabled: @Sendable () throws -> Bool
    var isTrendingMoviesEnabled: @Sendable () throws -> Bool
    var isPopularMoviesEnabled: @Sendable () throws -> Bool
    var isTrendingTVSeriesEnabled: @Sendable () throws -> Bool
    var isTrendingPeopleEnabled: @Sendable () throws -> Bool

}

extension ExploreClient: DependencyKey {

    static var liveValue: ExploreClient {
        @Dependency(\.fetchDiscoverMovies) var fetchDiscoverMovies
        @Dependency(\.fetchTrendingMovies) var fetchTrendingMovies
        @Dependency(\.fetchPopularMovies) var fetchPopularMovies
        @Dependency(\.fetchTrendingTVSeries) var fetchTrendingTVSeries
        @Dependency(\.fetchTrendingPeople) var fetchTrendingPeople
        @Dependency(\.featureFlags) var featureFlags

        return ExploreClient(
            fetchDiscoverMovies: {
                try await SpanContext.trace(
                    operation: "client.fetch",
                    description: "ExploreClient.fetchDiscoverMovies"
                ) { span in
                    let moviePreviews = try await fetchDiscoverMovies.execute()
                    let mapper = MoviePreviewMapper()
                    return moviePreviews.map(mapper.map)
                }
            },
            fetchTrendingMovies: {
                try await SpanContext.trace(
                    operation: "client.fetch",
                    description: "ExploreClient.fetchTrendingMovies"
                ) { _ in
                    let moviePreviews = try await fetchTrendingMovies.execute()
                    let mapper = MoviePreviewMapper()
                    return moviePreviews.map(mapper.map)
                }
            },
            fetchPopularMovies: {
                try await SpanContext.trace(
                    operation: "client.fetch",
                    description: "ExploreClient.fetchPopularMovies"
                ) { _ in
                    let moviePreviews = try await fetchPopularMovies.execute()
                    let mapper = MoviePreviewMapper()
                    return moviePreviews.map(mapper.map)
                }
            },
            fetchTrendingTVSeries: {
                try await SpanContext.trace(
                    operation: "client.fetch",
                    description: "ExploreClient.fetchTrendingTVSeries"
                ) { _ in
                    let tvSeriesPreviews = try await fetchTrendingTVSeries.execute()
                    let mapper = TVSeriesPreviewMapper()
                    return tvSeriesPreviews.map(mapper.map)
                }
            },
            fetchTrendingPeople: {
                try await SpanContext.trace(
                    operation: "client.fetch",
                    description: "ExploreClient.fetchTrendingPeople"
                ) { _ in
                    let personPreviews = try await fetchTrendingPeople.execute()
                    let mapper = PersonPreviewMapper()
                    return personPreviews.map(mapper.map)
                }
            },
            isDiscoverMoviesEnabled: {
                featureFlags.isEnabled(.exploreDiscoverMovies)
            },
            isTrendingMoviesEnabled: {
                featureFlags.isEnabled(.exploreTrendingMovies)
            },
            isPopularMoviesEnabled: {
                featureFlags.isEnabled(.explorePopularMovies)
            },
            isTrendingTVSeriesEnabled: {
                featureFlags.isEnabled(.exploreTrendingTVSeries)
            },
            isTrendingPeopleEnabled: {
                featureFlags.isEnabled(.exploreTrendingPeople)
            }
        )
    }

    static var previewValue: ExploreClient {
        ExploreClient(
            fetchDiscoverMovies: {
                try await Task.sleep(for: .seconds(2))
                return MoviePreview.mocks
            },
            fetchTrendingMovies: {
                try await Task.sleep(for: .seconds(2))
                return MoviePreview.mocks
            },
            fetchPopularMovies: {
                try await Task.sleep(for: .seconds(2))
                return MoviePreview.mocks
            },
            fetchTrendingTVSeries: {
                try await Task.sleep(for: .seconds(1))
                return TVSeriesPreview.mocks
            },
            fetchTrendingPeople: {
                try await Task.sleep(for: .seconds(2))
                return PersonPreview.mocks
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

extension DependencyValues {

    var exploreClient: ExploreClient {
        get {
            self[ExploreClient.self]
        }
        set {
            self[ExploreClient.self] = newValue
        }
    }

}
