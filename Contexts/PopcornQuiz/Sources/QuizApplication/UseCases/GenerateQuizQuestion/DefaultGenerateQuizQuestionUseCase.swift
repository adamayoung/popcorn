//
//  DefaultGenerateQuizQuestionUseCase.swift
//  PopcornQuiz
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import QuizDomain

final class DefaultGenerateQuizQuestionUseCase: GenerateQuizQuestionUseCase {

    private let movieProvider: MovieProviding
    private let riddleGenerator: SynopsisRiddleGenerating

    public init(
        movieProvider: MovieProviding,
        riddleGenerator: SynopsisRiddleGenerating
    ) {
        self.movieProvider = movieProvider
        self.riddleGenerator = riddleGenerator
    }

    func execute() async throws(GenerateQuizQuestionError) -> QuizQuestion {
        let theme = QuizTheme.allCases.randomElement() ?? .darkCryptic

        return try await execute(theme: theme)
    }

    func execute(theme: QuizTheme) async throws(GenerateQuizQuestionError) -> QuizQuestion {
        let movie = try await movieProvider.randomMovie()
        let riddle = try await riddleGenerator.riddle(for: movie, theme: theme)

        return QuizQuestion(movie: movie, riddle: riddle)
    }

}
