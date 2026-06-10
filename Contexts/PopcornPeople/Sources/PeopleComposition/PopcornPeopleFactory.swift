//
//  PopcornPeopleFactory.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleApplication
import PeopleDomain
import PeopleInfrastructure

public final class PopcornPeopleFactory: Sendable {

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

    public func makeFetchPersonDetailsUseCase() -> FetchPersonDetailsUseCase {
        applicationFactory.makeFetchPersonDetailsUseCase()
    }

}
