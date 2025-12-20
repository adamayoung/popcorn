//
//  GameQuestion.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct GameQuestion: Sendable, Equatable {

    public let id: UUID
    public let movie: Movie
    public let riddle: String
    public let options: [AnswerOption]

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
