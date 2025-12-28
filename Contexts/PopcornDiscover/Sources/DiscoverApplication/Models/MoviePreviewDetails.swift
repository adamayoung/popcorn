//
//  MoviePreviewDetails.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

///
/// Represents enriched movie preview data for display in discovery interfaces.
///
/// This model extends basic movie preview information with resolved genre objects
/// and complete image URL sets at various sizes, ready for UI presentation.
///
public struct MoviePreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// The movie's theatrical release date.
    public let releaseDate: Date

    /// Array of resolved genre objects for this movie.
    public let genres: [Genre]

    /// URL set for the movie's poster image at various sizes.
    public let posterURLSet: ImageURLSet?

    /// URL set for the movie's backdrop image at various sizes.
    public let backdropURLSet: ImageURLSet?

    /// URL set for the movie's logo image at various sizes.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new movie preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - releaseDate: The movie's theatrical release date.
    ///   - genres: Array of resolved genre objects.
    ///   - posterURLSet: URL set for poster images. Defaults to `nil`.
    ///   - backdropURLSet: URL set for backdrop images. Defaults to `nil`.
    ///   - logoURLSet: URL set for logo images. Defaults to `nil`.
    ///
    public init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: Date,
        genres: [Genre],
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.genres = genres
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
