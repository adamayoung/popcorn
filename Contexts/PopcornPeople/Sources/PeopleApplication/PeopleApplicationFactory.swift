//
//  PeopleApplicationFactory.swift
//  PopcornPeople
//
//  Created by Adam Young on 15/10/2025.
//

import Foundation
import PeopleDomain

package final class PeopleApplicationFactory {

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
