//
//  PeopleApplicationFactory.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain

public final class PeopleApplicationFactory: Sendable {

    private let personRepository: any PersonRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    public init(
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
