//
//  MoviePreviewPage.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A single page of trending movie previews for presentation.
///
/// Carries the ``MoviePreview`` values on one page together with the pagination
/// metadata ``TrendingMoviesViewModel`` needs to decide whether to request another
/// page.
public struct MoviePreviewPage: Equatable, Sendable {

    /// The number of this page, starting at `1`.
    public let page: Int

    /// The total number of pages available.
    public let totalPages: Int

    /// The trending movie previews on this page.
    public let movies: [MoviePreview]

    /// Whether at least one more page is available beyond this one.
    public var hasMore: Bool {
        page < totalPages
    }

    /// Creates a new page of trending movie previews.
    ///
    /// - Parameters:
    ///   - page: The number of this page, starting at `1`.
    ///   - totalPages: The total number of pages available.
    ///   - movies: The trending movie previews on this page.
    public init(page: Int, totalPages: Int, movies: [MoviePreview]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }

}
