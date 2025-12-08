//
//  QuizApplicationFactory.swift
//  PopcornQuiz
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import QuizDomain

public final class QuizApplicationFactory {

    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.appConfigurationProvider = appConfigurationProvider
    }

    //    public func makeFetchPersonDetailsUseCase() -> some FetchPersonDetailsUseCase {
    //        DefaultFetchPersonDetailsUseCase(
    //            repository: personRepository,
    //            appConfigurationProvider: appConfigurationProvider
    //        )
    //    }

}
