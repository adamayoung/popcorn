//
//  GameQuestion.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a single question in a Plot Remix game.
///
/// Each question presents a creatively remixed plot description (riddle) generated
/// according to the game's theme, along with multiple answer options where only one
/// correctly identifies the source movie. The movie property stores the complete details
/// of the correct answer for result presentation and verification.
///
public struct GameQuestion: Sendable, Equatable {

    /// The unique identifier for the question.
    public let id: UUID

    /// The movie that this question is based on and the correct answer.
    public let movie: Movie

    /// The creatively remixed plot description presented to the player.
    public let riddle: String

    /// The multiple choice answer options, including one correct answer.
    public let options: [AnswerOption]

    ///
    /// Creates a new game question.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the question. Defaults to a new UUID.
    ///   - movie: The movie that this question is based on.
    ///   - riddle: The remixed plot description.
    ///   - options: The multiple choice answer options.
    ///
    public init(
        id: UUID = .init(),
        movie: Movie,
        riddle: String,
        options: [AnswerOption]
    ) {
        self.id = id
        self.movie = movie
        self.riddle = riddle
        self.options = options
    }

}
