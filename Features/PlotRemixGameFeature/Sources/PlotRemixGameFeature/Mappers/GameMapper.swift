//
//  GameMapper.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
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
