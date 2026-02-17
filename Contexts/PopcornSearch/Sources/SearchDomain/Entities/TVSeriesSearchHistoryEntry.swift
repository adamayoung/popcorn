//
//  TVSeriesSearchHistoryEntry.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a TV series search history record.
///
/// This entity tracks when a user selected a specific TV series from search results,
/// enabling recent search functionality and personalized suggestions. The TV series ID
/// references the corresponding ``TVSeriesPreview`` entity, and the timestamp allows
/// for chronological ordering and time-based filtering of search history.
///
public struct TVSeriesSearchHistoryEntry: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series that was searched.
    public let id: Int

    /// The date and time when this TV series was selected from search results.
    public let timestamp: Date

    ///
    /// Creates a new TV series search history entry.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
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
