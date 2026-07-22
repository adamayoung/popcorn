//
//  PeopleApplicationFactory.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

package final class PeopleApplicationFactory: Sendable {

    private let personRepository: any PersonRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding

    package init(
        personRepository: some PersonRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        self.personRepository = personRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.movieLogoImageProvider = movieLogoImageProvider
        self.tvSeriesLogoImageProvider = tvSeriesLogoImageProvider
    }

    package func makeFetchPersonDetailsUseCase() -> some FetchPersonDetailsUseCase {
        DefaultFetchPersonDetailsUseCase(
            repository: personRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchPersonKnownForUseCase() -> some FetchPersonKnownForUseCase {
        DefaultFetchPersonKnownForUseCase(
            repository: personRepository,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider
        )
    }

}
