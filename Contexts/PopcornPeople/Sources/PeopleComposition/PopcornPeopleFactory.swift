//
//  PopcornPeopleFactory.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleApplication
import PeopleDomain
import PeopleInfrastructure

public struct PopcornPeopleFactory {

    private let applicationFactory: PeopleApplicationFactory

    public init(
        personRemoteDataSource: some PersonRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        let infrastructureFactory = PeopleInfrastructureFactory(
            personRemoteDataSource: personRemoteDataSource
        )
        self.applicationFactory = PeopleApplicationFactory(
            personRepository: infrastructureFactory.makePersonRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchPersonDetailsUseCase() -> some FetchPersonDetailsUseCase {
        applicationFactory.makeFetchPersonDetailsUseCase()
    }

}
