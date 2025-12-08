//
//  ExploreClient.swift
//  ExploreFeature
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication
import MoviesKitAdapters
import TrendingApplication
import TrendingKitAdapters

struct ExploreClient: Sendable {

    var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]
    var fetchPopularMovies: @Sendable () async throws -> [MoviePreview]
    var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]
    var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

}

extension ExploreClient: DependencyKey {

    static var liveValue: ExploreClient {
        ExploreClient(
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
            fetchTrendingMovies: {
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
            },
            fetchPopularMovies: {
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
            },
            fetchTrendingTVSeries: {
                try await Task.sleep(for: .seconds(1))
                return [
                    TVSeriesPreview(
                        id: 225171,
                        name: "Pluribus",
                        posterURL: URL(
                            string:
                                "https://image.tmdb.org/t/p/w780/nrM2xFUfKJJEmZzd5d7kohT2G0C.jpg")
                    ),
                    TVSeriesPreview(
                        id: 66732,
                        name: "Stranger Things",
                        posterURL: URL(
                            string:
                                "https://image.tmdb.org/t/p/w780/cVxVGwHce6xnW8UaVUggaPXbmoE.jpg")
                    )
                ]
            },
            fetchTrendingPeople: {
                try await Task.sleep(for: .seconds(2))
                return [
                    PersonPreview(
                        id: 234352,
                        name: "Margot Robbie",
                        profileURL: URL(
                            string:
                                "https://image.tmdb.org/t/p/h632/euDPyqLnuwaWMHajcU3oZ9uZezR.jpg")
                    ),
                    PersonPreview(
                        id: 2283,
                        name: "Stanley Tucci",
                        profileURL: URL(
                            string:
                                "https://image.tmdb.org/t/p/h632/q4TanMDI5Rgsvw4SfyNbPBh4URr.jpg")
                    )
                ]
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
