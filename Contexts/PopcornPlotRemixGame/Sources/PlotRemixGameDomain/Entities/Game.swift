//
//  Game.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a complete Plot Remix game session.
///
/// A game consists of multiple questions, each presenting a creatively remixed movie plot
/// that players must identify from multiple choice options. The game's settings determine
/// the narrative style, genre filtering, and release year constraints that shape the
/// question generation process.
///
public struct Game: Sendable {

    /// The unique identifier for the game session.
    public let id: UUID

    /// The configuration settings that define how questions are generated and presented.
    public let settings: Game.Settings

    /// The sequence of questions to be answered in this game session.
    public let questions: [GameQuestion]

    ///
    /// Creates a new game instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the game session.
    ///   - settings: The configuration settings for question generation.
    ///   - questions: The sequence of questions in the game.
    ///
    public init(
        id: UUID,
        settings: Game.Settings,
        questions: [GameQuestion]
    ) {
        self.id = id
        self.settings = settings
        self.questions = questions
    }

}

public extension Game {

    ///
    /// Configuration settings that define how a Plot Remix game is generated and played.
    ///
    /// These settings control the narrative style through the theme, filter movie selection
    /// by genre and release year, and ensure consistency across all questions in a game session.
    ///
    struct Settings: Sendable {

        /// The narrative style used to remix movie plots in questions.
        public let theme: GameTheme

        /// The genre filter applied to movie selection for questions.
        public let genre: Genre

        /// The release year constraints for movie selection.
        public let primaryReleaseYear: PrimaryReleaseYearFilter

        ///
        /// Creates new game settings.
        ///
        /// - Parameters:
        ///   - theme: The narrative style for plot remixes.
        ///   - genre: The genre filter for movie selection.
        ///   - primaryReleaseYear: The release year constraints.
        ///
        public init(
            theme: GameTheme,
            genre: Genre,
            primaryReleaseYear: PrimaryReleaseYearFilter
        ) {
            self.theme = theme
            self.genre = genre
            self.primaryReleaseYear = primaryReleaseYear
        }
    }

}
