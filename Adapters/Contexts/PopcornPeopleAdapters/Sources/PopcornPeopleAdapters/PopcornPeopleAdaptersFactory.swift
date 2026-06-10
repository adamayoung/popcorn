//
//  PopcornPeopleAdaptersFactory.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import PeopleDomain
import PeopleInfrastructure
import TMDb

/// Builds the People context's TMDb-backed adapters (port implementations).
///
/// This factory is responsible only for adapting external services to the
/// People context's ports. Assembling the context's factory from these adapters
/// is the composition root's responsibility, so the adapters layer stays a leaf
/// and never depends on the context's composition module.
public final class PopcornPeopleAdaptersFactory {

    private let personService: any TMDb.PersonService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        personService: some TMDb.PersonService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.personService = personService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makePersonRemoteDataSource() -> some PersonRemoteDataSource {
        TMDbPersonRemoteDataSource(personService: personService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

}
