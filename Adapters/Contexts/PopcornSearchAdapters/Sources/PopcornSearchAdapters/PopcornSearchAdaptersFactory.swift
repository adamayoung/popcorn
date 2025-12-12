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
import SearchApplication
import TMDb
import TMDbAdapters
import TVApplication

struct PopcornSearchAdaptersFactory {

    let searchService: any SearchService
    let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase
    let fetchPersonDetailsUseCase: any FetchPersonDetailsUseCase

    func makeSearchFactory() -> SearchApplicationFactory {
        let mediaRemoteDataSource = TMDbMediaRemoteDataSource(searchService: searchService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        let mediaProvider = MediaProviderAdapter(
            fetchMovieUseCase: fetchMovieDetailsUseCase,
            fetchTVSeriesUseCase: fetchTVSeriesDetailsUseCase,
            fetchPersonUseCase: fetchPersonDetailsUseCase
        )

        return SearchComposition.makeSearchFactory(
            mediaRemoteDataSource: mediaRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            mediaProvider: mediaProvider
        )
    }

}
