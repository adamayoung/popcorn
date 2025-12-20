//
//  GameQuestionMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain

struct GameQuestionMapper {

    func map(_ question: PlotRemixGameDomain.GameQuestion) -> GameQuestion {
        let movieMapper = MovieMapper()
        let movie = movieMapper.map(question.movie)
        let options = question.options.map(map)

        return GameQuestion(
            id: question.id,
            movie: movie,
            riddle: question.riddle,
            options: options
        )
    }

    private func map(_ option: PlotRemixGameDomain.AnswerOption) -> AnswerOption {
        AnswerOption(
            id: option.id,
            title: option.title,
            isCorrect: option.isCorrect
        )
    }

}
