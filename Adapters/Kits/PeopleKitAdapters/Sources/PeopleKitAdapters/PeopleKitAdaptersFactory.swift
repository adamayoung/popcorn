//
//  PeopleKitAdaptersFactory.swift
//  PeopleKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ConfigurationApplication
import Foundation
import PeopleApplication
import TMDb

struct PeopleKitAdaptersFactory {

    let personService: any PersonService
    let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    func makePeopleFactory() -> PeopleApplicationFactory {
        let personRemoteDataSource = TMDbPersonRemoteDataSource(personService: personService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase)

        return PeopleComposition.makePeopleFactory(
            personRemoteDataSource: personRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
