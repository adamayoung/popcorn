//
//  Genre.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a genre in the discover context.
///
/// This entity is used within the discover context to categorize and filter
/// movies and TV series by genre. It maintains the same structure as the
/// shared genre entity but is scoped to the discover domain.
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
