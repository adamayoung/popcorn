//
//  MovieDetailsClient.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import MoviesApplication

@DependencyClient
struct MovieDetailsClient: Sendable {

    var streamMovie: @Sendable (Int) async throws -> AsyncThrowingStream<Movie?, Error>
    var streamSimilar: @Sendable (Int) async throws -> AsyncThrowingStream<[MoviePreview], Error>
    var toggleOnWatchlist: @Sendable (Int) async throws -> Void

    var isWatchlistEnabled: @Sendable () throws -> Bool

}

extension MovieDetailsClient: DependencyKey {

    static var liveValue: MovieDetailsClient {
        @Dependency(\.streamMovieDetails) var streamMovieDetails
        @Dependency(\.streamSimilarMovies) var streamSimilarMovies
        @Dependency(\.toggleWatchlistMovie) var toggleWatchlistMovie
        @Dependency(\.featureFlags) var featureFlags

        return MovieDetailsClient(
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
            streamSimilar: { id in
                let moviePreviewStream = await streamSimilarMovies.stream(movieID: id, limit: 5)
                return AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    let task = Task {
                        let mapper = MoviePreviewMapper()
                        for try await moviePreviews in moviePreviewStream {
                            continuation.yield(moviePreviews.map(mapper.map))
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            },
            toggleOnWatchlist: { id in
                try await toggleWatchlistMovie.execute(id: id)
            },
            isWatchlistEnabled: {
                featureFlags.isEnabled(.watchlist)
            }
        )
    }

    static var previewValue: MovieDetailsClient {
        MovieDetailsClient(
            streamMovie: { _ in
                AsyncThrowingStream<Movie?, Error> { continuation in
                    continuation.yield(Movie.mock)
                    continuation.finish()
                }
            },
            streamSimilar: { _ in
                AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    continuation.yield(MoviePreview.mocks)
                    continuation.finish()
                }
            },
            toggleOnWatchlist: { _ in },
            isWatchlistEnabled: {
                true
            }
        )
    }

}

extension DependencyValues {

    var movieDetailsClient: MovieDetailsClient {
        get { self[MovieDetailsClient.self] }
        set { self[MovieDetailsClient.self] = newValue }
    }

}
