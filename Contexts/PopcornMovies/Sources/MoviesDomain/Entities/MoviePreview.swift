//
//  MoviePreview.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a lightweight preview of a movie.
///
/// This entity contains the same information as ``Movie`` but is semantically used
/// in contexts where only basic movie information is needed, such as in lists,
/// search results, or related movie collections. The separation allows for clearer
/// domain boundaries and potential future divergence of properties.
///
public struct MoviePreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// The movie's theatrical release date, if known.
    public let releaseDate: Date?

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
    ///   - releaseDate: The movie's theatrical release date. Defaults to `nil`.
    ///   - posterPath: URL path to the poster image. Defaults to `nil`.
    ///   - backdropPath: URL path to the backdrop image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
