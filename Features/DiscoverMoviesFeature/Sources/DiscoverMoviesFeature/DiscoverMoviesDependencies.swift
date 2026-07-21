//
//  DiscoverMoviesDependencies.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``DiscoverMoviesViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``DiscoverMoviesViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct DiscoverMoviesDependencies: Sendable {

    /// Fetches a page of discover movies for the given page number.
    public var fetchDiscoverMovies: @Sendable (_ page: Int) async throws -> MoviePreviewPage

    /// Creates the discover movies dependencies.
    ///
    /// - Parameter fetchDiscoverMovies: Fetches a page of discover movies for the
    ///   given page number.
    public init(
        fetchDiscoverMovies: @escaping @Sendable (_ page: Int) async throws -> MoviePreviewPage
    ) {
        self.fetchDiscoverMovies = fetchDiscoverMovies
    }

}

#if DEBUG
    public extension DiscoverMoviesDependencies {

        /// Mock dependencies for previews and snapshot tests. Reports a single page,
        /// so the load-more footer never appears.
        static var preview: DiscoverMoviesDependencies {
            DiscoverMoviesDependencies(
                fetchDiscoverMovies: { page in
                    MoviePreviewPage(page: page, totalPages: 1, movies: MoviePreview.mocks)
                }
            )
        }

    }
#endif
