//
//  PeopleApplicationFactory.swift
//  PeopleKit
//
//  Created by Adam Young on 15/10/2025.
//

import Foundation
import PeopleDomain

public final class PeopleApplicationFactory {

    private let personRepository: any PersonRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        personRepository: some PersonRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.personRepository = personRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    public func makeFetchPersonDetailsUseCase() -> some FetchPersonDetailsUseCase {
        DefaultFetchPersonDetailsUseCase(
            repository: personRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
