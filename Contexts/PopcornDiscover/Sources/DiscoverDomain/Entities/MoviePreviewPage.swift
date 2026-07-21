//
//  MoviePreviewPage.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A single page of discovered movie previews.
///
/// Wraps the ``MoviePreview`` values on one page together with the pagination
/// metadata needed to decide whether — and which — further pages to request: the
/// current page number and the total number of pages available from the source.
///
public struct MoviePreviewPage: Equatable, Sendable {

    /// The number of this page, starting at `1`.
    public let page: Int

    /// The total number of pages available.
    public let totalPages: Int

    /// The discovered movie previews on this page.
    public let movies: [MoviePreview]

    ///
    /// Creates a new page of discovered movie previews.
    ///
    /// - Parameters:
    ///   - page: The number of this page, starting at `1`.
    ///   - totalPages: The total number of pages available.
    ///   - movies: The discovered movie previews on this page.
    ///
    public init(page: Int, totalPages: Int, movies: [MoviePreview]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }

}
