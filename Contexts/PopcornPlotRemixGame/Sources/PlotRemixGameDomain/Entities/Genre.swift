//
//  Genre.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a movie genre for filtering Plot Remix game content.
///
/// Genres allow players to focus game questions on specific types of films, such as
/// action, comedy, or horror. This is a Plot Remix context-specific entity, separate
/// from genre entities in other contexts, tailored specifically for game configuration
/// and movie filtering during question generation.
///
public struct Genre: Sendable, Equatable, Identifiable {

    /// The unique identifier for the genre.
    public let id: Int

    /// The display name of the genre.
    public let name: String

    ///
    /// Creates a new genre.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the genre.
    ///   - name: The display name of the genre.
    ///
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
