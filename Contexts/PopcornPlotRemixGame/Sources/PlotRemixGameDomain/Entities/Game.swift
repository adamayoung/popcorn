//
//  Game.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation

public struct Game: Sendable {

    public let id: UUID
    public let settings: Game.Settings
    public let questions: [GameQuestion]

    public init(
        id: UUID,
        settings: Game.Settings,
        questions: [GameQuestion]
    ) {
        self.id = id
        self.settings = settings
        self.questions = questions
    }

}

extension Game {

    public struct Settings: Sendable {
        public let theme: GameTheme
        public let genre: Genre
        public let primaryReleaseYear: PrimaryReleaseYearFilter

        public init(
            theme: GameTheme,
            genre: Genre,
            primaryReleaseYear: PrimaryReleaseYearFilter
        ) {
            self.theme = theme
            self.genre = genre
            self.primaryReleaseYear = primaryReleaseYear
        }
    }

}
