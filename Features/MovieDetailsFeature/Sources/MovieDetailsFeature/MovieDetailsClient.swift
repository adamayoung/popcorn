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
    var streamRecommended: @Sendable (Int) async throws -> AsyncThrowingStream<[MoviePreview], Error>
    var toggleOnWatchlist: @Sendable (Int) async throws -> Void

    var isWatchlistEnabled: @Sendable () throws -> Bool
    var isIntelligenceEnabled: @Sendable () throws -> Bool

}

extension MovieDetailsClient: DependencyKey {

    static var liveValue: MovieDetailsClient {
        @Dependency(\.streamMovieDetails) var streamMovieDetails
        @Dependency(\.streamMovieRecommendations) var streamMovieRecommendations
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
            streamRecommended: { id in
                let moviePreviewStream = await streamMovieRecommendations.stream(movieID: id, limit: 5)
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
            },
            isIntelligenceEnabled: {
                featureFlags.isEnabled(.movieIntelligence)
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
            streamRecommended: { _ in
                AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    continuation.yield(MoviePreview.mocks)
                    continuation.finish()
                }
            },
            toggleOnWatchlist: { _ in },
            isWatchlistEnabled: { true },
            isIntelligenceEnabled: { true }
        )
    }

}

extension DependencyValues {

    var movieDetailsClient: MovieDetailsClient {
        get { self[MovieDetailsClient.self] }
        set { self[MovieDetailsClient.self] = newValue }
    }

}
