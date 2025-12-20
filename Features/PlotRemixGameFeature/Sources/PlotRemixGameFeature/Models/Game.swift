//
//  Game.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct Game: Identifiable, Sendable {

    public let id: UUID
    public let questions: [GameQuestion]

    public init(
        id: UUID,
        questions: [GameQuestion]
    ) {
        self.id = id
        self.questions = questions
    }

}

extension Game {

    // swiftlint:disable line_length
    static var mock: Game {
        Game(
            id: UUID(),
            questions: [
                GameQuestion(
                    id: UUID(),
                    movie: Movie(
                        id: 118,
                        title: "Charlie and the Chocolate Factory",
                        overview:
                        "A young boy wins a tour through the most magnificent chocolate factory in the world, led by the world's most unusual candy maker.",
                        posterPath: URL(string: "/iKP6wg3c6COUe8gYutoGG7qcPnO.jpg"),
                        backdropPath: URL(string: "/atoIgfAk2Ig2HFJLD0VUnjiPWEz.jpg")
                    ),
                    riddle:
                    "A reclusive chocolatier invites local kids on a tour of his factory.",
                    options: AnswerOption.mocks
                )
            ]
        )
    }
    // swiftlint:enable line_length

}
