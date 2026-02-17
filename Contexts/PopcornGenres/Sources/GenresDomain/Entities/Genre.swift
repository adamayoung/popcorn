//
//  Genre.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a movie or TV series genre.
///
/// Genres categorize movies and TV series into thematic groups (e.g., Action, Comedy, Drama).
/// This entity is shared across different contexts to maintain consistent genre identification
/// and naming throughout the application.
///
public struct Genre: Sendable, Equatable, Identifiable {

    /// The unique identifier for the genre.
    public let id: Int

    /// The human-readable name of the genre (e.g., "Action", "Comedy").
    public let name: String

    ///
    /// Creates a new genre instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the genre.
    ///   - name: The human-readable name of the genre.
    ///
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
