//
//  PopcornTrendingAdaptersFactory.swift
//  PopcornTrendingAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ConfigurationApplication
import Foundation
import MoviesApplication
import TMDb
import TMDbAdapters
import TVApplication
import TrendingApplication

struct PopcornTrendingAdaptersFactory {

    let trendingService: any TrendingService
    let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    func makeTrendingFactory() -> TrendingApplicationFactory {
        let trendingRemoteDataSource = TMDbTrendingRemoteDataSource(
            trendingService: trendingService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        let movieLogoProvider = MovieLogoImageProviderAdapter(
            fetchImageCollectionUseCase: fetchMovieImageCollectionUseCase
        )
        let tvSeriesLogoProvider = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollectionUseCase
        )

        return TrendingComposition.makeTrendingFactory(
            trendingRemoteDataSource: trendingRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoProvider
        )
    }

}
