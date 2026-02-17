//
//  ExploreClient.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import DiscoverApplication
import Foundation
import MoviesApplication
import Observability
import OSLog
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
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "ExploreClient.fetchDiscoverMovies"
                )
                do {
                    let moviePreviews = try await fetchDiscoverMovies.execute()
                    let mapper = MoviePreviewMapper()
                    let result = moviePreviews.map(mapper.map)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw error
                }
            },
            fetchTrendingMovies: {
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "ExploreClient.fetchTrendingMovies"
                )
                do {
                    let moviePreviews = try await fetchTrendingMovies.execute()
                    let mapper = MoviePreviewMapper()
                    let result = moviePreviews.map(mapper.map)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw error
                }
            },
            fetchPopularMovies: {
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "ExploreClient.fetchPopularMovies"
                )
                do {
                    let moviePreviews = try await fetchPopularMovies.execute()
                    let mapper = MoviePreviewMapper()
                    let result = moviePreviews.map(mapper.map)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw error
                }
            },
            fetchTrendingTVSeries: {
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "ExploreClient.fetchTrendingTVSeries"
                )
                do {
                    let tvSeriesPreviews = try await fetchTrendingTVSeries.execute()
                    let mapper = TVSeriesPreviewMapper()
                    let result = tvSeriesPreviews.map(mapper.map)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw error
                }
            },
            fetchTrendingPeople: {
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "ExploreClient.fetchTrendingPeople"
                )
                do {
                    let personPreviews = try await fetchTrendingPeople.execute()
                    let mapper = PersonPreviewMapper()
                    let result = personPreviews.map(mapper.map)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw error
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
