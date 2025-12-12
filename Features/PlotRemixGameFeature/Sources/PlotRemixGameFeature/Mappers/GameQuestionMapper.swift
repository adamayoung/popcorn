//
//  GameQuestionMapper.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
//

import Foundation
import PlotRemixGameDomain

struct GameQuestionMapper {

    func map(_ question: PlotRemixGameDomain.GameQuestion) -> GameQuestion {
        let movieMapper = MovieMapper()
        let movie = movieMapper.map(question.movie)

        return GameQuestion(
            id: question.id,
            movie: movie,
            riddle: question.riddle
        )
    }

}
