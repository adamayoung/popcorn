//
//  TrendingMoviesClient.swift
//  TrendingMoviesFeature
//
//  Created by Adam Young on 17/11/2025.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import TrendingApplication

@DependencyClient
struct TrendingMoviesClient: Sendable {

    var fetch: @Sendable () async throws -> [MoviePreview]

}

extension TrendingMoviesClient: DependencyKey {

    static var liveValue: TrendingMoviesClient {
        @Dependency(\.fetchTrendingMovies) var fetchTrendingMovies

        return TrendingMoviesClient(
            fetch: {
                let moviePreviews = try await fetchTrendingMovies.execute()
                let mapper = MoviePreviewMapper()
                return moviePreviews.map(mapper.map)
            }
        )
    }

    static var previewValue: TrendingMoviesClient {
        TrendingMoviesClient(
            fetch: {
                try await Task.sleep(for: .seconds(2))

                return [
                    MoviePreview(
                        id: 1,
                        title: "The Running Man",
                        posterURL: URL(
                            string:
                                "https://image.tmdb.org/t/p/w780/dKL78O9zxczVgjtNcQ9UkbYLzqX.jpg")
                    ),
                    MoviePreview(
                        id: 2,
                        title: "Black Phone 2",
                        posterURL: URL(
                            string:
                                "https://image.tmdb.org/t/p/w780/xUWUODKPIilQoFUzjHM6wKJkP3Y.jpg")
                    )
                ]
            }
        )
    }

}

extension DependencyValues {

    var trendingMovies: TrendingMoviesClient {
        get {
            self[TrendingMoviesClient.self]
        }
        set {
            self[TrendingMoviesClient.self] = newValue
        }
    }

}
