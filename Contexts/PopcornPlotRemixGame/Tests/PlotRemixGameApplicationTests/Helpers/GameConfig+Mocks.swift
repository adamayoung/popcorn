//
//  GameConfig+Mocks.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

extension GameConfig {

    static func mock(
        theme: GameTheme = .whimsical,
        genreID: Int? = nil,
        primaryReleaseYearFilter: PrimaryReleaseYearFilter? = nil
    ) -> GameConfig {
        GameConfig(
            theme: theme,
            genreID: genreID,
            primaryReleaseYearFilter: primaryReleaseYearFilter
        )
    }

}
