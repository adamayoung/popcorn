//
//  GameMapper.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

/// Maps a context ``PlotRemixGameDomain/Game`` to the feature's ``Game`` presentation model.
public struct GameMapper {

    /// Creates a game mapper.
    public init() {}

    /// Maps a context ``PlotRemixGameDomain/Game`` to a presentation ``Game``.
    public func map(_ game: PlotRemixGameDomain.Game) -> Game {
        let questionMapper = GameQuestionMapper()
        let questions = game.questions.map(questionMapper.map)

        return Game(
            id: game.id,
            questions: questions
        )
    }

}
