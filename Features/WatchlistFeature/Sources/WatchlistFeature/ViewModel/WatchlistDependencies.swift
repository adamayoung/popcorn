//
//  WatchlistDependencies.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import MoviesApplication

/// The dependencies required by ``WatchlistViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``WatchlistViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. Build the production instance with
/// ``live(services:)``.
public struct WatchlistDependencies: Sendable {

    public var fetchWatchlistMovies: @Sendable () async throws -> [MoviePreview]
    public var streamWatchlistMovies: @Sendable () async throws -> AsyncThrowingStream<[MoviePreview], Error>

    public init(
        fetchWatchlistMovies: @escaping @Sendable () async throws -> [MoviePreview],
        streamWatchlistMovies: @escaping @Sendable () async throws -> AsyncThrowingStream<[MoviePreview], Error>
    ) {
        self.fetchWatchlistMovies = fetchWatchlistMovies
        self.streamWatchlistMovies = streamWatchlistMovies
    }

}

public extension WatchlistDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Wires the fetch and stream watchlist use cases with their mapper and
    /// translates domain errors to ``FetchWatchlistError``.
    static func live(services: AppServices) -> WatchlistDependencies {
        let fetchWatchlistMovies = services.moviesFactory.makeFetchWatchlistMoviesUseCase()
        let streamWatchlistMovies = services.moviesFactory.makeStreamWatchlistMoviesUseCase()

        return WatchlistDependencies(
            fetchWatchlistMovies: {
                do {
                    let moviePreviews = try await fetchWatchlistMovies.execute()
                    let mapper = MoviePreviewMapper()
                    return moviePreviews.map(mapper.map)
                } catch let error as FetchWatchlistMoviesError {
                    throw FetchWatchlistError(error)
                }
            },
            streamWatchlistMovies: {
                let moviesStream = await streamWatchlistMovies.stream()
                return AsyncThrowingStream<[MoviePreview], Error> { continuation in
                    let task = Task {
                        let mapper = MoviePreviewMapper()
                        do {
                            for try await moviePreviews in moviesStream {
                                continuation.yield(moviePreviews.map(mapper.map))
                            }
                            continuation.finish()
                        } catch {
                            continuation.finish(throwing: error)
                        }
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            }
        )
    }

}

#if DEBUG
    public extension WatchlistDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: WatchlistDependencies {
            WatchlistDependencies(
                fetchWatchlistMovies: {
                    MoviePreview.mocks
                },
                streamWatchlistMovies: {
                    AsyncThrowingStream<[MoviePreview], Error> { continuation in
                        continuation.yield(MoviePreview.mocks)
                        continuation.finish()
                    }
                }
            )
        }

    }
#endif
