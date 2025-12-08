//
//  QuizComposition.swift
//  PopcornQuiz
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import QuizDomain
import QuizInfrastructure

public struct QuizComposition {

    private init() {}

    public static func makeQuizFactory(
        appConfigurationProvider: some AppConfigurationProviding
    ) -> QuizApplicationFactory {
        //        let infrastructureFactory = QuizInfrastructureFactory()
        //        let personRepository = infrastructureFactory.makePersonRepository()

        QuizApplicationFactory(
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
