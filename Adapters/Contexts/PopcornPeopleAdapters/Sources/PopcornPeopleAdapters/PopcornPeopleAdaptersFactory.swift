//
//  PopcornPeopleAdaptersFactory.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import MoviesApplication
import PeopleDomain
import PeopleInfrastructure
import TMDb
import TVSeriesApplication

/// Builds the People context's TMDb-backed adapters (port implementations).
public final class PopcornPeopleAdaptersFactory {

    private let personService: any TMDb.PersonService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    public init(
        personService: some TMDb.PersonService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieImageCollectionUseCase: some FetchMovieImageCollectionUseCase,
        fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase
    ) {
        self.personService = personService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieImageCollectionUseCase = fetchMovieImageCollectionUseCase
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
    }

    public func makePersonRemoteDataSource() -> some PersonRemoteDataSource {
        TMDbPersonRemoteDataSource(personService: personService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

    public func makeMovieLogoImageProvider() -> some MovieLogoImageProviding {
        MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: fetchMovieImageCollectionUseCase)
    }

    public func makeTVSeriesLogoImageProvider() -> some TVSeriesLogoImageProviding {
        TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollectionUseCase
        )
    }

}
