//
//  ToggleWatchlistMovieUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case that toggles a movie's watchlist status.
///
/// This protocol defines the contract for adding or removing a movie from the
/// user's personal watchlist. If the movie is currently on the watchlist, it
/// will be removed; otherwise, it will be added.
///
public protocol ToggleWatchlistMovieUseCase: Sendable {

    ///
    /// Toggles the watchlist status for a movie.
    ///
    /// This method first verifies the movie exists, then adds or removes it
    /// from the watchlist based on its current status.
    ///
    /// - Parameter id: The unique identifier of the movie to toggle.
    /// - Throws: ``ToggleWatchlistMovieError`` if the operation fails.
    ///
    func execute(id: Int) async throws(ToggleWatchlistMovieError)

}
