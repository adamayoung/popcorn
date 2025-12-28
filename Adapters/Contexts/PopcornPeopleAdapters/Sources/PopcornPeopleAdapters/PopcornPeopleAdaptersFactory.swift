//
//  PopcornPeopleAdaptersFactory.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import Foundation
import PeopleComposition
import TMDb

///
/// A factory for creating people-related adapters.
///
/// Creates adapters that bridge TMDb person services to the application's
/// people domain.
///
public final class PopcornPeopleAdaptersFactory {

    private let personService: any PersonService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    ///
    /// Creates a people adapters factory.
    ///
    /// - Parameters:
    ///   - personService: The TMDb person service.
    ///   - fetchAppConfigurationUseCase: The use case for fetching app configuration.
    ///
    public init(
        personService: some PersonService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.personService = personService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    ///
    /// Creates a people factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornPeopleFactory`` instance.
    ///
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
