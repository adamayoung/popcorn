//
//  PopcornSearchAdaptersFactory.swift
//  PopcornSearchAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ConfigurationApplication
import Foundation
import MoviesApplication
import PeopleApplication
import PopcornMoviesAdapters
import PopcornPeopleAdapters
import PopcornTVAdapters
import SearchComposition
import TMDb
import TVApplication

public final class PopcornSearchAdaptersFactory {

    private let searchService: any SearchService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase
    private let fetchPersonDetailsUseCase: any FetchPersonDetailsUseCase

    public init(
        searchService: some SearchService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase,
        fetchTVSeriesDetailsUseCase: some FetchTVSeriesDetailsUseCase,
        fetchPersonDetailsUseCase: some FetchPersonDetailsUseCase
    ) {
        self.searchService = searchService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchTVSeriesDetailsUseCase = fetchTVSeriesDetailsUseCase
        self.fetchPersonDetailsUseCase = fetchPersonDetailsUseCase
    }

    public func makeSearchFactory() -> PopcornSearchFactory {
        let mediaRemoteDataSource = TMDbMediaRemoteDataSource(searchService: searchService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        let mediaProvider = MediaProviderAdapter(
            fetchMovieUseCase: fetchMovieDetailsUseCase,
            fetchTVSeriesUseCase: fetchTVSeriesDetailsUseCase,
            fetchPersonUseCase: fetchPersonDetailsUseCase
        )

        return PopcornSearchFactory(
            mediaRemoteDataSource: mediaRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            mediaProvider: mediaProvider
        )
    }

}
