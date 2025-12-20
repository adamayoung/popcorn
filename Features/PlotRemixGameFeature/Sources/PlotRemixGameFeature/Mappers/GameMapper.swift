//
//  GameMapper.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain

struct GameMapper {

    func map(_ game: PlotRemixGameDomain.Game) -> Game {
        let questionMapper = GameQuestionMapper()
        let questions = game.questions.map(questionMapper.map)

        return Game(
            id: game.id,
            questions: questions
        )
    }

}
