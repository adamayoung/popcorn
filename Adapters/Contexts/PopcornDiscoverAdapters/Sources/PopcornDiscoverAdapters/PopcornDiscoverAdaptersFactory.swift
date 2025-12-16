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
import TVSeriesApplication

public final class PopcornDiscoverAdaptersFactory {

    private let discoverService: any DiscoverService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    private let fetchTVSeriesGenresUseCase: any FetchTVSeriesGenresUseCase
    private let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    public init(
        discoverService: some DiscoverService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieGenresUseCase: some FetchMovieGenresUseCase,
        fetchTVSeriesGenresUseCase: some FetchTVSeriesGenresUseCase,
        fetchMovieImageCollectionUseCase: some FetchMovieImageCollectionUseCase,
        fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase
    ) {
        self.discoverService = discoverService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
        self.fetchTVSeriesGenresUseCase = fetchTVSeriesGenresUseCase
        self.fetchMovieImageCollectionUseCase = fetchMovieImageCollectionUseCase
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
    }

    public func makeDiscoverFactory() -> PopcornDiscoverFactory {
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
