//
//  MoviePreview.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a simplified movie preview in search results.
///
/// This entity provides essential movie information optimized for search result displays,
/// containing only the core details needed for quick browsing and selection. Unlike the
/// full ``Movie`` entity in other contexts, this preview excludes detailed metadata like
/// release dates to minimize data transfer and improve search performance.
///
public struct MoviePreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// URL path to the movie's poster image.
    public let posterPath: URL?

    /// URL path to the movie's backdrop image.
    public let backdropPath: URL?

    ///
    /// Creates a new movie preview instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - posterPath: URL path to the poster image. Defaults to `nil`.
    ///   - backdropPath: URL path to the backdrop image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
