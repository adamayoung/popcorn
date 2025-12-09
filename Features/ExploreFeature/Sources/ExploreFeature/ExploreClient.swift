//
//  ExploreClient.swift
//  ExploreFeature
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import DiscoverApplication
import Foundation
import MoviesApplication
import PopcornDiscoverAdapters
import PopcornMoviesAdapters
import PopcornTrendingAdapters
import TrendingApplication

struct ExploreClient: Sendable {

    var fetchDiscoverMovies: @Sendable () async throws -> [MoviePreview]
    var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]
    var fetchPopularMovies: @Sendable () async throws -> [MoviePreview]
    var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]
    var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

}

extension ExploreClient: DependencyKey {

    static var liveValue: ExploreClient {
        ExploreClient(
            fetchDiscoverMovies: {
                let useCase = DependencyValues._current.fetchDiscoverMovies
                let moviePreviews = try await useCase.execute()
                let mapper = MoviePreviewMapper()
                let movies = moviePreviews.map(mapper.map)
                return movies
            },
            fetchTrendingMovies: {
                let useCase = DependencyValues._current.fetchTrendingMovies
                let moviePreviews = try await useCase.execute()
                let mapper = MoviePreviewMapper()
                let movies = moviePreviews.map(mapper.map)
                return movies
            },
            fetchPopularMovies: {
                let useCase = DependencyValues._current.fetchPopularMovies
                let moviePreviews = try await useCase.execute()
                let mapper = MoviePreviewMapper()
                return moviePreviews.map(mapper.map)
            },
            fetchTrendingTVSeries: {
                let useCase = DependencyValues._current.fetchTrendingTVSeries
                let tvSeriesPreviews = try await useCase.execute()
                let mapper = TVSeriesPreviewMapper()
                return tvSeriesPreviews.map(mapper.map)
            },
            fetchTrendingPeople: {
                let useCase = DependencyValues._current.fetchTrendingPeople
                let personPreviews = try await useCase.execute()
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

    var explore: ExploreClient {
        get {
            self[ExploreClient.self]
        }
        set {
            self[ExploreClient.self] = newValue
        }
    }

}
