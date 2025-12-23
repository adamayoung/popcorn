//
//  MovieSearchHistoryEntry.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a movie search history record.
///
/// This entity tracks when a user selected a specific movie from search results,
/// enabling recent search functionality and personalized suggestions. The movie ID
/// references the corresponding ``MoviePreview`` entity, and the timestamp allows
/// for chronological ordering and time-based filtering of search history.
///
public struct MovieSearchHistoryEntry: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie that was searched.
    public let id: Int

    /// The date and time when this movie was selected from search results.
    public let timestamp: Date

    ///
    /// Creates a new movie search history entry.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - timestamp: The date and time of the search. Defaults to the current date and time.
    ///
    public init(
        id: Int,
        timestamp: Date = .now
    ) {
        self.id = id
        self.timestamp = timestamp
    }

}
