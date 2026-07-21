//
//  MoviePreviewDetailsPage.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A single page of detailed trending movie previews.
///
/// Wraps the ``MoviePreviewDetails`` values on one page together with the
/// pagination metadata needed to request further pages: the current page number
/// and the total number of pages available.
///
public struct MoviePreviewDetailsPage: Equatable, Sendable {

    /// The number of this page, starting at `1`.
    public let page: Int

    /// The total number of pages available.
    public let totalPages: Int

    /// The detailed trending movie previews on this page.
    public let movies: [MoviePreviewDetails]

    ///
    /// Creates a new page of detailed trending movie previews.
    ///
    /// - Parameters:
    ///   - page: The number of this page, starting at `1`.
    ///   - totalPages: The total number of pages available.
    ///   - movies: The detailed trending movie previews on this page.
    ///
    public init(page: Int, totalPages: Int, movies: [MoviePreviewDetails]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }

}
