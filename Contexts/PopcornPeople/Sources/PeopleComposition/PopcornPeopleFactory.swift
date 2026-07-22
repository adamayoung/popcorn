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
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        let infrastructureFactory = PeopleInfrastructureFactory(
            personRemoteDataSource: personRemoteDataSource
        )
        self.applicationFactory = PeopleApplicationFactory(
            personRepository: infrastructureFactory.makePersonRepository(),
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider
        )
    }

    public func makeFetchPersonDetailsUseCase() -> FetchPersonDetailsUseCase {
        applicationFactory.makeFetchPersonDetailsUseCase()
    }

    public func makeFetchPersonKnownForUseCase() -> FetchPersonKnownForUseCase {
        applicationFactory.makeFetchPersonKnownForUseCase()
    }

    /// Makes a use case that fetches every movie and TV series a person is credited on.
    ///
    /// - Returns: A ``FetchPersonCreditsUseCase``.
    public func makeFetchPersonCreditsUseCase() -> FetchPersonCreditsUseCase {
        applicationFactory.makeFetchPersonCreditsUseCase()
    }

}
