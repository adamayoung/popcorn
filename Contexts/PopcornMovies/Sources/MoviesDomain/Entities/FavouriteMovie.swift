//
//  FavouriteMovie.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a movie in the user's watchlist.
///
/// This entity tracks when a movie was added to the watchlist, enabling
/// chronological sorting and management of watchlist items. The movie ID
/// references the corresponding ``Movie`` entity.
///
public struct WatchlistMovie: Identifiable, Equatable, Hashable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The date and time when this movie was added to the watchlist.
    public let createdAt: Date

    ///
    /// Creates a new watchlist movie instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - createdAt: The date when the movie was added to the watchlist.
    ///
    public init(id: Int, createdAt: Date) {
        self.id = id
        self.createdAt = createdAt
    }

}
