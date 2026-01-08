//
//  TrendingMoviesClient.swift
//  TrendingMoviesFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import TrendingApplication

@DependencyClient
struct TrendingMoviesClient: Sendable {

    var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]

}

extension TrendingMoviesClient: DependencyKey {

    static var liveValue: TrendingMoviesClient {
        @Dependency(\.fetchTrendingMovies) var fetchTrendingMovies

        return TrendingMoviesClient(
            fetchTrendingMovies: {
                let moviePreviews = try await fetchTrendingMovies.execute()
                let mapper = MoviePreviewMapper()
                return moviePreviews.map(mapper.map)
            }
        )
    }

    static var previewValue: TrendingMoviesClient {
        TrendingMoviesClient(
            fetchTrendingMovies: {
                MoviePreview.mocks
            }
        )
    }

}

extension DependencyValues {

    var trendingMoviesClient: TrendingMoviesClient {
        get {
            self[TrendingMoviesClient.self]
        }
        set {
            self[TrendingMoviesClient.self] = newValue
        }
    }

}
