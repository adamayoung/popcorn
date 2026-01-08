//
//  PeopleApplicationFactory.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain

package final class PeopleApplicationFactory: Sendable {

    private let personRepository: any PersonRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    package init(
        personRepository: some PersonRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.personRepository = personRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    package func makeFetchPersonDetailsUseCase() -> some FetchPersonDetailsUseCase {
        DefaultFetchPersonDetailsUseCase(
            repository: personRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
