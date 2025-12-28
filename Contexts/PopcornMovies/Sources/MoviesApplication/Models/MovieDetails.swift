//
//  MovieDetails.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents comprehensive movie details ready for presentation.
///
/// This model combines movie information from multiple sources into a single
/// presentation-ready object. It includes resolved image URLs at multiple sizes
/// and the current watchlist status for the user.
///
public struct MovieDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// The movie's theatrical release date, if known.
    public let releaseDate: Date?

    /// A set of poster image URLs at various resolutions.
    public let posterURLSet: ImageURLSet?

    /// A set of backdrop image URLs at various resolutions.
    public let backdropURLSet: ImageURLSet?

    /// A set of logo image URLs at various resolutions.
    public let logoURLSet: ImageURLSet?

    /// Whether this movie is on the user's watchlist.
    public let isOnWatchlist: Bool

    ///
    /// Creates a new movie details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - releaseDate: The movie's theatrical release date. Defaults to `nil`.
    ///   - posterURLSet: A set of poster image URLs. Defaults to `nil`.
    ///   - backdropURLSet: A set of backdrop image URLs. Defaults to `nil`.
    ///   - logoURLSet: A set of logo image URLs. Defaults to `nil`.
    ///   - isOnWatchlist: Whether the movie is on the user's watchlist.
    ///
    public init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: Date? = nil,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil,
        isOnWatchlist: Bool
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
        self.isOnWatchlist = isOnWatchlist
    }

}
