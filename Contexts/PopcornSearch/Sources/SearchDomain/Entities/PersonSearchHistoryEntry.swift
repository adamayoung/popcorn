//
//  PersonSearchHistoryEntry.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a person search history record.
///
/// This entity tracks when a user selected a specific person from search results,
/// enabling recent search functionality and personalized suggestions. The person ID
/// references the corresponding ``PersonPreview`` entity, and the timestamp allows
/// for chronological ordering and time-based filtering of search history.
///
public struct PersonSearchHistoryEntry: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person that was searched.
    public let id: Int

    /// The date and time when this person was selected from search results.
    public let timestamp: Date

    ///
    /// Creates a new person search history entry.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
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
