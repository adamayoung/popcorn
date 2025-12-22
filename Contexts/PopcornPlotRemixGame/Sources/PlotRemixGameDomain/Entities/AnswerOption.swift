//
//  AnswerOption.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a possible answer choice in a Plot Remix game question.
///
/// Each answer option presents a movie title that could potentially match the remixed
/// plot description shown to the player. Only one option per question should be marked
/// as correct. Answer options are displayed in random order during gameplay to prevent
/// positional biases.
///
public struct AnswerOption: Identifiable, Sendable, Equatable {

    /// The unique identifier for the answer option.
    public let id: Int

    /// The movie title presented as a possible answer.
    public let title: String

    /// Indicates whether this option is the correct answer to the question.
    public let isCorrect: Bool

    ///
    /// Creates a new answer option.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the answer option.
    ///   - title: The movie title presented as a possible answer.
    ///   - isCorrect: Whether this option is the correct answer.
    ///
    public init(id: Int, title: String, isCorrect: Bool) {
        self.id = id
        self.title = title
        self.isCorrect = isCorrect
    }

}
