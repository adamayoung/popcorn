//
//  GameQuestionTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameDomain
import Testing

@Suite("GameQuestion")
struct GameQuestionTests {

    @Test("init assigns provided id, movie, riddle and options")
    func initAssignsProvidedValues() {
        let id = UUID()
        let movie = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)
        let options = [AnswerOption(id: 1, title: "Movie", isCorrect: true)]

        let question = GameQuestion(id: id, movie: movie, riddle: "A riddle", options: options)

        #expect(question.id == id)
        #expect(question.movie == movie)
        #expect(question.riddle == "A riddle")
        #expect(question.options == options)
    }

    @Test("init generates a default id when none is provided")
    func initGeneratesDefaultID() {
        let movie = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)

        let question = GameQuestion(movie: movie, riddle: "A riddle", options: [])

        #expect(question.id != UUID())
    }

    @Test("default ids differ between separately created questions")
    func defaultIDsDifferBetweenInstances() {
        let movie = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)

        let first = GameQuestion(movie: movie, riddle: "A riddle", options: [])
        let second = GameQuestion(movie: movie, riddle: "A riddle", options: [])

        #expect(first.id != second.id)
    }

    @Test("equality fails when riddle differs")
    func equalityFailsWhenRiddleDiffers() {
        let id = UUID()
        let movie = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)

        let first = GameQuestion(id: id, movie: movie, riddle: "Riddle A", options: [])
        let second = GameQuestion(id: id, movie: movie, riddle: "Riddle B", options: [])

        #expect(first != second)
    }

    @Test("equality fails when options differ")
    func equalityFailsWhenOptionsDiffer() {
        let id = UUID()
        let movie = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)

        let first = GameQuestion(
            id: id, movie: movie, riddle: "A riddle",
            options: [AnswerOption(id: 1, title: "Movie", isCorrect: true)]
        )
        let second = GameQuestion(id: id, movie: movie, riddle: "A riddle", options: [])

        #expect(first != second)
    }

}
