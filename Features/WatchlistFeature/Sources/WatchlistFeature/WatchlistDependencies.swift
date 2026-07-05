//
//  WatchlistDependencies.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``WatchlistViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``WatchlistViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
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
