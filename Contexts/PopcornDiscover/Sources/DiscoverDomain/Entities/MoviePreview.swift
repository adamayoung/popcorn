//
//  MoviePreview.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a movie preview in the discover context.
///
/// This entity extends the basic movie preview with genre information, enabling
/// users to discover and browse movies by genre. It includes all essential movie
/// details needed for displaying in discovery lists and grids.
///
public struct MoviePreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// The movie's theatrical release date.
    public let releaseDate: Date

    /// Array of genre IDs associated with this movie.
    public let genreIDs: [Int]

    /// URL path to the movie's poster image.
    public let posterPath: URL?

    /// URL path to the movie's backdrop image.
    public let backdropPath: URL?

    ///
    /// Creates a new discover movie preview instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - releaseDate: The movie's theatrical release date.
    ///   - genreIDs: Array of genre IDs for this movie.
    ///   - posterPath: URL path to the poster image. Defaults to `nil`.
    ///   - backdropPath: URL path to the backdrop image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: Date,
        genreIDs: [Int],
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIDs = genreIDs
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
