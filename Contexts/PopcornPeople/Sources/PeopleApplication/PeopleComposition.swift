//
//  PeopleComposition.swift
//  PopcornPeople
//
//  Created by Adam Young on 20/11/2025.
//

import Foundation
import PeopleDomain
import PeopleInfrastructure

public struct PeopleComposition {

    private init() {}

    public static func makePeopleFactory(
        personRemoteDataSource: some PersonRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) -> PeopleApplicationFactory {
        let infrastructureFactory = PeopleInfrastructureFactory(
            personRemoteDataSource: personRemoteDataSource
        )
        let personRepository = infrastructureFactory.makePersonRepository()

        return PeopleApplicationFactory(
            personRepository: personRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
