//
//  MovieDetailsDependencies.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``MovieDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``MovieDetailsViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct MovieDetailsDependencies: Sendable {

    public var fetchMovie: @Sendable (_ id: Int) async throws -> Movie
    public var streamMovie: @Sendable (_ id: Int) async throws -> AsyncThrowingStream<Movie?, Error>
    public var fetchRecommendedMovies: @Sendable (_ movieID: Int) async throws -> [MoviePreview]
    public var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits
    public var toggleOnWatchlist: @Sendable (_ movieID: Int) async throws -> Void

    public var isWatchlistEnabled: @Sendable () throws -> Bool
    public var isIntelligenceEnabled: @Sendable () throws -> Bool
    public var isCastAndCrewEnabled: @Sendable () throws -> Bool
    public var isRecommendedMoviesEnabled: @Sendable () throws -> Bool
    public var isBackdropFocalPointEnabled: @Sendable () throws -> Bool

    public init(
        fetchMovie: @escaping @Sendable (_ id: Int) async throws -> Movie,
        streamMovie: @escaping @Sendable (_ id: Int) async throws -> AsyncThrowingStream<Movie?, Error>,
        fetchRecommendedMovies: @escaping @Sendable (_ movieID: Int) async throws -> [MoviePreview],
        fetchCredits: @escaping @Sendable (_ movieID: Int) async throws -> Credits,
        toggleOnWatchlist: @escaping @Sendable (_ movieID: Int) async throws -> Void,
        isWatchlistEnabled: @escaping @Sendable () throws -> Bool,
        isIntelligenceEnabled: @escaping @Sendable () throws -> Bool,
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool,
        isRecommendedMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isBackdropFocalPointEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchMovie = fetchMovie
        self.streamMovie = streamMovie
        self.fetchRecommendedMovies = fetchRecommendedMovies
        self.fetchCredits = fetchCredits
        self.toggleOnWatchlist = toggleOnWatchlist
        self.isWatchlistEnabled = isWatchlistEnabled
        self.isIntelligenceEnabled = isIntelligenceEnabled
        self.isCastAndCrewEnabled = isCastAndCrewEnabled
        self.isRecommendedMoviesEnabled = isRecommendedMoviesEnabled
        self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
    }

}

#if DEBUG
    public extension MovieDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: MovieDetailsDependencies {
            MovieDetailsDependencies(
                fetchMovie: { _ in Movie.mock },
                streamMovie: { _ in
                    AsyncThrowingStream<Movie?, Error> { continuation in
                        continuation.yield(Movie.mock)
                        continuation.finish()
                    }
                },
                fetchRecommendedMovies: { _ in MoviePreview.mocks },
                fetchCredits: { _ in Credits.mock },
                toggleOnWatchlist: { _ in },
                isWatchlistEnabled: { true },
                isIntelligenceEnabled: { true },
                isCastAndCrewEnabled: { true },
                isRecommendedMoviesEnabled: { true },
                isBackdropFocalPointEnabled: { true }
            )
        }

    }
#endif
