//
//  GameMapperTests.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain
import Testing

@testable import PlotRemixGameFeature

@Suite("GameMapper Tests")
struct GameMapperTests {

    private let mapper = GameMapper()

    @Test("Maps Game with all properties")
    func mapsGameWithAllProperties() {
        let gameID = UUID()
        let questionID = UUID()
        let domainMovie = PlotRemixGameDomain.Movie(
            id: 118,
            title: "Charlie and the Chocolate Factory",
            overview: "A young boy wins a tour.",
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )
        let domainOptions = [
            PlotRemixGameDomain.AnswerOption(id: 1, title: "Wrong", isCorrect: false),
            PlotRemixGameDomain.AnswerOption(id: 118, title: "Charlie and the Chocolate Factory", isCorrect: true)
        ]
        let domainQuestion = PlotRemixGameDomain.GameQuestion(
            id: questionID,
            movie: domainMovie,
            riddle: "A chocolatier invites kids.",
            options: domainOptions
        )
        let settings = PlotRemixGameDomain.Game.Settings(
            theme: .whimsical,
            genre: PlotRemixGameDomain.Genre(id: 35, name: "Comedy"),
            primaryReleaseYear: .fromYear(2000)
        )
        let domainGame = PlotRemixGameDomain.Game(
            id: gameID,
            settings: settings,
            questions: [domainQuestion]
        )

        let result = mapper.map(domainGame)

        #expect(result.id == gameID)
        #expect(result.questions.count == 1)
        #expect(result.questions[0].id == questionID)
        #expect(result.questions[0].movie.id == 118)
        #expect(result.questions[0].riddle == "A chocolatier invites kids.")
        #expect(result.questions[0].options.count == 2)
    }

    @Test("Maps Game with empty questions")
    func mapsGameWithEmptyQuestions() {
        let gameID = UUID()
        let settings = PlotRemixGameDomain.Game.Settings(
            theme: .noir,
            genre: PlotRemixGameDomain.Genre(id: 28, name: "Action"),
            primaryReleaseYear: .onYear(2020)
        )
        let domainGame = PlotRemixGameDomain.Game(
            id: gameID,
            settings: settings,
            questions: []
        )

        let result = mapper.map(domainGame)

        #expect(result.id == gameID)
        #expect(result.questions.isEmpty)
    }

    @Test("Maps Game with multiple questions")
    func mapsGameWithMultipleQuestions() {
        let gameID = UUID()
        let movie1 = PlotRemixGameDomain.Movie(
            id: 1,
            title: "Movie 1",
            overview: "Overview 1",
            posterPath: nil,
            backdropPath: nil
        )
        let movie2 = PlotRemixGameDomain.Movie(
            id: 2,
            title: "Movie 2",
            overview: "Overview 2",
            posterPath: nil,
            backdropPath: nil
        )
        let question1 = PlotRemixGameDomain.GameQuestion(
            id: UUID(),
            movie: movie1,
            riddle: "Riddle 1",
            options: []
        )
        let question2 = PlotRemixGameDomain.GameQuestion(
            id: UUID(),
            movie: movie2,
            riddle: "Riddle 2",
            options: []
        )
        let settings = PlotRemixGameDomain.Game.Settings(
            theme: .fairyTale,
            genre: PlotRemixGameDomain.Genre(id: 14, name: "Fantasy"),
            primaryReleaseYear: .betweenYears(start: 1990, end: 2010)
        )
        let domainGame = PlotRemixGameDomain.Game(
            id: gameID,
            settings: settings,
            questions: [question1, question2]
        )

        let result = mapper.map(domainGame)

        #expect(result.id == gameID)
        #expect(result.questions.count == 2)
        #expect(result.questions[0].movie.id == 1)
        #expect(result.questions[0].riddle == "Riddle 1")
        #expect(result.questions[1].movie.id == 2)
        #expect(result.questions[1].riddle == "Riddle 2")
    }

}
