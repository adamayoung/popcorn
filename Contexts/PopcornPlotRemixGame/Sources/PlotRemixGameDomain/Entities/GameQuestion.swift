//
//  GameQuestion.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
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
