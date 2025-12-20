//
//  PopcornPeopleAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import Foundation
import PeopleComposition
import TMDb

public final class PopcornPeopleAdaptersFactory {

    private let personService: any PersonService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        personService: some PersonService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.personService = personService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makePeopleFactory() -> PopcornPeopleFactory {
        let personRemoteDataSource = TMDbPersonRemoteDataSource(personService: personService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase)

        return PopcornPeopleFactory(
            personRemoteDataSource: personRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
