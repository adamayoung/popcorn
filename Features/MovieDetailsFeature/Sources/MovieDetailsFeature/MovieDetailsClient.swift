//
//  MovieDetailsClient.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import MoviesApplication

@DependencyClient
struct MovieDetailsClient: Sendable {

    var fetchMovie: @Sendable (_ id: Int) async throws -> Movie
    var streamMovie: @Sendable (_ id: Int) async throws -> AsyncThrowingStream<Movie?, Error>
    var fetchRecommendedMovies: @Sendable (_ movieID: Int) async throws -> [MoviePreview]
    var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits
    var toggleOnWatchlist: @Sendable (_ movieID: Int) async throws -> Void

    var isWatchlistEnabled: @Sendable () throws -> Bool
    var isIntelligenceEnabled: @Sendable () throws -> Bool
    var isBackdropFocalPointEnabled: @Sendable () throws -> Bool

}

extension MovieDetailsClient: DependencyKey {

    static var liveValue: MovieDetailsClient {
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails
        @Dependency(\.streamMovieDetails) var streamMovieDetails
        @Dependency(\.fetchMovieRecommendations) var fetchMovieRecommendations
        @Dependency(\.fetchMovieCredits) var fetchMovieCredits
        @Dependency(\.toggleWatchlistMovie) var toggleWatchlistMovie
        @Dependency(\.featureFlags) var featureFlags

        return MovieDetailsClient(
            fetchMovie: { id in
                let movie = try await fetchMovieDetails.execute(id: id)
                let mapper = MovieMapper()
                return mapper.map(movie)
            },
            streamMovie: { id in
                let movieStream = await streamMovieDetails.stream(id: id)
                return AsyncThrowingStream<Movie?, Error> { continuation in
                    let task = Task {
                        let mapper = MovieMapper()
                        for try await movie in movieStream {
                            guard let movie else {
                                continuation.yield(nil)
                                continue
                            }

                            continuation.yield(mapper.map(movie))
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            },
            fetchRecommendedMovies: { movieID in
                let movies = try await fetchMovieRecommendations.execute(movieID: movieID)
                let mapper = MoviePreviewMapper()
                return movies.prefix(5).map(mapper.map)
            },
            fetchCredits: { movieID in
                let credits = try await fetchMovieCredits.execute(movieID: movieID)
                let mapper = CreditsMapper()
                return mapper.map(credits)
            },
            toggleOnWatchlist: { id in
                try await toggleWatchlistMovie.execute(id: id)
            },
            isWatchlistEnabled: {
                featureFlags.isEnabled(.watchlist)
            },
            isIntelligenceEnabled: {
                featureFlags.isEnabled(.movieIntelligence)
            },
            isBackdropFocalPointEnabled: {
                featureFlags.isEnabled(.backdropFocalPoint)
            }
        )
    }

    static var previewValue: MovieDetailsClient {
        MovieDetailsClient(
            fetchMovie: { _ in
                Movie.mock
            },
            streamMovie: { _ in
                AsyncThrowingStream<Movie?, Error> { continuation in
                    continuation.yield(Movie.mock)
                    continuation.finish()
                }
            },
            fetchRecommendedMovies: { _ in
                MoviePreview.mocks
            },
            fetchCredits: { _ in
                Credits.mock
            },
            toggleOnWatchlist: { _ in },
            isWatchlistEnabled: { true },
            isIntelligenceEnabled: { true },
            isBackdropFocalPointEnabled: { true }
        )
    }

}

extension DependencyValues {

    var movieDetailsClient: MovieDetailsClient {
        get { self[MovieDetailsClient.self] }
        set { self[MovieDetailsClient.self] = newValue }
    }

}
