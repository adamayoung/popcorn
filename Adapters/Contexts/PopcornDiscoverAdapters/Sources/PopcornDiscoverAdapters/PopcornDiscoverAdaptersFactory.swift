//
//  PopcornDiscoverAdaptersFactory.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import ConfigurationApplication
import DiscoverComposition
import Foundation
import GenresApplication
import MoviesApplication
import TMDb
import TVApplication

struct PopcornDiscoverAdaptersFactory {

    let discoverService: any DiscoverService
    let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    let fetchTVSeriesGenresUseCase: any FetchTVSeriesGenresUseCase
    let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    func makeDiscoverFactory() -> PopcornDiscoverFactory {
        let discoverRemoteDataSource = TMDbDiscoverRemoteDataSource(
            discoverService: discoverService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        let genreProvider = GenreProviderAdapter(
            fetchMovieGenresUseCase: fetchMovieGenresUseCase,
            fetchTVSeriesGenresUseCase: fetchTVSeriesGenresUseCase
        )

        let movieLogoProvider = MovieLogoImageProviderAdapter(
            fetchImageCollectionUseCase: fetchMovieImageCollectionUseCase
        )
        let tvSeriesLogoProvider = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollectionUseCase
        )

        return PopcornDiscoverFactory(
            discoverRemoteDataSource: discoverRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            genreProvider: genreProvider,
            movieLogoImageProvider: movieLogoProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoProvider
        )
    }

}
