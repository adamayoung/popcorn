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

///
/// Factory for creating use cases in the PopcornPeople module.
///
/// This is the main entry point for consumers of the PopcornPeople module.
/// It composes all internal layers (domain, application, infrastructure) and
/// exposes ready-to-use use cases.
///
public struct PopcornPeopleFactory {

    private let applicationFactory: PeopleApplicationFactory

    ///
    /// Creates a new PopcornPeople factory.
    ///
    /// - Parameters:
    ///   - personRemoteDataSource: The data source for fetching person data from a remote API.
    ///   - appConfigurationProvider: The provider for application configuration settings.
    ///
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

    ///
    /// Creates a use case for fetching person details.
    ///
    /// - Returns: A configured ``FetchPersonDetailsUseCase`` implementation.
    ///
    public func makeFetchPersonDetailsUseCase() -> some FetchPersonDetailsUseCase {
        applicationFactory.makeFetchPersonDetailsUseCase()
    }

}
