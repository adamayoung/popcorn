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
import TrendingApplication

@DependencyClient
struct ExploreClient: Sendable {

    var fetchDiscoverMovies: @Sendable () async throws -> [MoviePreview]
    var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]
    var fetchPopularMovies: @Sendable () async throws -> [MoviePreview]
    var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]
    var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

}

extension ExploreClient: DependencyKey {

    static var liveValue: ExploreClient {
        @Dependency(\.fetchDiscoverMovies) var fetchDiscoverMovies
        @Dependency(\.fetchTrendingMovies) var fetchTrendingMovies
        @Dependency(\.fetchPopularMovies) var fetchPopularMovies
        @Dependency(\.fetchTrendingTVSeries) var fetchTrendingTVSeries
        @Dependency(\.fetchTrendingPeople) var fetchTrendingPeople

        return ExploreClient(
            fetchDiscoverMovies: {
                let moviePreviews = try await fetchDiscoverMovies.execute()
                let mapper = MoviePreviewMapper()
                let movies = moviePreviews.map(mapper.map)
                return movies
            },
            fetchTrendingMovies: {
                let moviePreviews = try await fetchTrendingMovies.execute()
                let mapper = MoviePreviewMapper()
                let movies = moviePreviews.map(mapper.map)
                return movies
            },
            fetchPopularMovies: {
                let moviePreviews = try await fetchPopularMovies.execute()
                let mapper = MoviePreviewMapper()
                return moviePreviews.map(mapper.map)
            },
            fetchTrendingTVSeries: {
                let tvSeriesPreviews = try await fetchTrendingTVSeries.execute()
                let mapper = TVSeriesPreviewMapper()
                return tvSeriesPreviews.map(mapper.map)
            },
            fetchTrendingPeople: {
                let personPreviews = try await fetchTrendingPeople.execute()
                let mapper = PersonPreviewMapper()
                return personPreviews.map(mapper.map)
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
