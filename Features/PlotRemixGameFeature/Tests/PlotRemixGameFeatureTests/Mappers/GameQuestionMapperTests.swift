//
//  GameQuestionMapperTests.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain
@testable import PlotRemixGameFeature
import Testing

@Suite("GameQuestionMapper Tests")
struct GameQuestionMapperTests {

    private let mapper = GameQuestionMapper()

    @Test("Maps GameQuestion with all properties")
    func mapsGameQuestionWithAllProperties() {
        let questionID = UUID()
        let domainMovie = PlotRemixGameDomain.Movie(
            id: 118,
            title: "Charlie and the Chocolate Factory",
            overview: "A young boy wins a tour through the chocolate factory.",
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )
        let domainOptions = [
            PlotRemixGameDomain.AnswerOption(id: 1, title: "Wrong Movie 1", isCorrect: false),
            PlotRemixGameDomain.AnswerOption(id: 118, title: "Charlie and the Chocolate Factory", isCorrect: true),
            PlotRemixGameDomain.AnswerOption(id: 2, title: "Wrong Movie 2", isCorrect: false)
        ]
        let domainQuestion = PlotRemixGameDomain.GameQuestion(
            id: questionID,
            movie: domainMovie,
            riddle: "A reclusive chocolatier invites local kids on a tour.",
            options: domainOptions
        )

        let result = mapper.map(domainQuestion)

        #expect(result.id == questionID)
        #expect(result.riddle == "A reclusive chocolatier invites local kids on a tour.")
        #expect(result.movie.id == 118)
        #expect(result.movie.title == "Charlie and the Chocolate Factory")
        #expect(result.options.count == 3)
        #expect(result.options[0].id == 1)
        #expect(result.options[0].title == "Wrong Movie 1")
        #expect(result.options[0].isCorrect == false)
        #expect(result.options[1].id == 118)
        #expect(result.options[1].isCorrect == true)
    }

    @Test("Maps AnswerOption correctly")
    func mapsAnswerOptionCorrectly() {
        let domainMovie = PlotRemixGameDomain.Movie(
            id: 1,
            title: "Test",
            overview: "Test",
            posterPath: nil,
            backdropPath: nil
        )
        let correctOption = PlotRemixGameDomain.AnswerOption(id: 1, title: "Correct Answer", isCorrect: true)
        let incorrectOption = PlotRemixGameDomain.AnswerOption(id: 2, title: "Wrong Answer", isCorrect: false)
        let domainQuestion = PlotRemixGameDomain.GameQuestion(
            id: UUID(),
            movie: domainMovie,
            riddle: "Test riddle",
            options: [correctOption, incorrectOption]
        )

        let result = mapper.map(domainQuestion)

        #expect(result.options.count == 2)
        #expect(result.options[0].id == 1)
        #expect(result.options[0].title == "Correct Answer")
        #expect(result.options[0].isCorrect == true)
        #expect(result.options[1].id == 2)
        #expect(result.options[1].title == "Wrong Answer")
        #expect(result.options[1].isCorrect == false)
    }

    @Test("Maps question with empty options")
    func mapsQuestionWithEmptyOptions() {
        let domainMovie = PlotRemixGameDomain.Movie(
            id: 1,
            title: "Test",
            overview: "Test",
            posterPath: nil,
            backdropPath: nil
        )
        let domainQuestion = PlotRemixGameDomain.GameQuestion(
            id: UUID(),
            movie: domainMovie,
            riddle: "Test riddle",
            options: []
        )

        let result = mapper.map(domainQuestion)

        #expect(result.options.isEmpty)
    }

    @Test("Maps multiple questions correctly")
    func mapsMultipleQuestions() {
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

        let results = [question1, question2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].movie.id == 1)
        #expect(results[0].riddle == "Riddle 1")
        #expect(results[1].movie.id == 2)
        #expect(results[1].riddle == "Riddle 2")
    }

}
