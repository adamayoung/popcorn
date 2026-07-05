//
//  AnswerOptionTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

@testable import PlotRemixGameDomain
import Testing

@Suite("AnswerOption")
struct AnswerOptionTests {

    @Test("init assigns provided values for a correct answer")
    func initAssignsValuesForCorrectAnswer() {
        let option = AnswerOption(id: 42, title: "Fight Club", isCorrect: true)

        #expect(option.id == 42)
        #expect(option.title == "Fight Club")
        #expect(option.isCorrect)
    }

    @Test("init assigns provided values for an incorrect answer")
    func initAssignsValuesForIncorrectAnswer() {
        let option = AnswerOption(id: 7, title: "Se7en", isCorrect: false)

        #expect(option.id == 7)
        #expect(option.title == "Se7en")
        #expect(!option.isCorrect)
    }

    @Test("equality holds for options with identical values")
    func equalityHoldsForIdenticalValues() {
        let first = AnswerOption(id: 1, title: "Movie", isCorrect: true)
        let second = AnswerOption(id: 1, title: "Movie", isCorrect: true)

        #expect(first == second)
    }

    @Test("equality fails when id differs")
    func equalityFailsWhenIDDiffers() {
        let first = AnswerOption(id: 1, title: "Movie", isCorrect: true)
        let second = AnswerOption(id: 2, title: "Movie", isCorrect: true)

        #expect(first != second)
    }

    @Test("equality fails when title differs")
    func equalityFailsWhenTitleDiffers() {
        let first = AnswerOption(id: 1, title: "Movie A", isCorrect: true)
        let second = AnswerOption(id: 1, title: "Movie B", isCorrect: true)

        #expect(first != second)
    }

    @Test("equality fails when isCorrect differs")
    func equalityFailsWhenIsCorrectDiffers() {
        let first = AnswerOption(id: 1, title: "Movie", isCorrect: true)
        let second = AnswerOption(id: 1, title: "Movie", isCorrect: false)

        #expect(first != second)
    }

}
