//
//  GameTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameDomain
import Testing

@Suite("Game")
struct GameTests {

    @Test("init assigns provided id, settings and questions")
    func initAssignsProvidedValues() {
        let id = UUID()
        let settings = Game.Settings(
            theme: .whimsical,
            genre: Genre(id: 28, name: "Action"),
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )
        let movie = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)
        let questions = [GameQuestion(movie: movie, riddle: "A riddle", options: [])]

        let game = Game(id: id, settings: settings, questions: questions)

        #expect(game.id == id)
        #expect(game.settings.theme == .whimsical)
        #expect(game.settings.genre == Genre(id: 28, name: "Action"))
        #expect(game.settings.primaryReleaseYear == .betweenYears(start: 1980, end: 2025))
        #expect(game.questions == questions)
    }

    @Test("init assigns an empty questions array")
    func initAssignsEmptyQuestions() {
        let game = Game(
            id: UUID(),
            settings: Game.Settings(
                theme: .whimsical,
                genre: Genre(id: 28, name: "Action"),
                primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
            ),
            questions: []
        )

        #expect(game.questions.isEmpty)
    }

}

@Suite("Game.Settings")
struct GameSettingsTests {

    @Test("init assigns provided theme, genre and primaryReleaseYear")
    func initAssignsProvidedValues() {
        let genre = Genre(id: 35, name: "Comedy")

        let settings = Game.Settings(
            theme: .pirate,
            genre: genre,
            primaryReleaseYear: .fromYear(2010)
        )

        #expect(settings.theme == .pirate)
        #expect(settings.genre == genre)
        #expect(settings.primaryReleaseYear == .fromYear(2010))
    }

}
