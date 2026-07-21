//
//  PopularMoviesDependencies.swift
//  PopularMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``PopularMoviesViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``PopularMoviesViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct PopularMoviesDependencies: Sendable {

    public var fetchPopularMovies: @Sendable (_ page: Int) async throws -> MoviePreviewPage

    public init(
        fetchPopularMovies: @escaping @Sendable (_ page: Int) async throws -> MoviePreviewPage
    ) {
        self.fetchPopularMovies = fetchPopularMovies
    }

}

#if DEBUG
    public extension PopularMoviesDependencies {

        /// Mock dependencies for previews and snapshot tests. Reports a single page,
        /// so the load-more footer never appears.
        static var preview: PopularMoviesDependencies {
            PopularMoviesDependencies(
                fetchPopularMovies: { page in
                    MoviePreviewPage(page: page, totalPages: 1, movies: MoviePreview.mocks)
                }
            )
        }

    }
#endif
