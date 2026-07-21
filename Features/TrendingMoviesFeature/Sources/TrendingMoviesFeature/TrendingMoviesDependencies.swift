//
//  TrendingMoviesDependencies.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``TrendingMoviesViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TrendingMoviesViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct TrendingMoviesDependencies: Sendable {

    public var fetchTrendingMovies: @Sendable (_ page: Int) async throws -> MoviePreviewPage

    public init(
        fetchTrendingMovies: @escaping @Sendable (_ page: Int) async throws -> MoviePreviewPage
    ) {
        self.fetchTrendingMovies = fetchTrendingMovies
    }

}

#if DEBUG
    public extension TrendingMoviesDependencies {

        /// Mock dependencies for previews and snapshot tests. Reports a single page,
        /// so the load-more footer never appears.
        static var preview: TrendingMoviesDependencies {
            TrendingMoviesDependencies(
                fetchTrendingMovies: { page in
                    MoviePreviewPage(page: page, totalPages: 1, movies: MoviePreview.mocks)
                }
            )
        }

    }
#endif
