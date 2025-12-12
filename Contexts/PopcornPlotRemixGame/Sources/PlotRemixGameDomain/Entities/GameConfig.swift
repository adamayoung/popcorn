//
//  GameConfig.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 10/12/2025.
//

import Foundation

public struct GameConfig: Sendable {

    public let theme: GameTheme
    public let genreID: Int?
    public let primaryReleaseYearFilter: PrimaryReleaseYearFilter?

    public init(
        theme: GameTheme,
        genreID: Int? = nil,
        primaryReleaseYearFilter: PrimaryReleaseYearFilter? = nil
    ) {
        self.theme = theme
        self.genreID = genreID
        self.primaryReleaseYearFilter = primaryReleaseYearFilter
    }

}
