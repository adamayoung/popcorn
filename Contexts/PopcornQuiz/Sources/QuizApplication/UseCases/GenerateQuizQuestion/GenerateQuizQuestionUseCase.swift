//
//  GenerateQuizQuestionUseCase.swift
//  PopcornQuiz
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import QuizDomain

public protocol GenerateQuizQuestionUseCase: Sendable {

    func execute() async throws(GenerateQuizQuestionError) -> QuizQuestion

    func execute(theme: QuizTheme) async throws(GenerateQuizQuestionError) -> QuizQuestion

}
