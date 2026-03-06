//
//  PopcornTrendingAdaptersFactory.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Foundation
import MoviesApplication
import TMDb
import TrendingComposition
import TVSeriesApplication

public final class PopcornTrendingAdaptersFactory {

    private let trendingService: any TrendingService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase
    private let themeColorProvider: (any ThemeColorProviding)?

    public init(
        trendingService: some TrendingService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieImageCollectionUseCase: some FetchMovieImageCollectionUseCase,
        fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.trendingService = trendingService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieImageCollectionUseCase = fetchMovieImageCollectionUseCase
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
        self.themeColorProvider = themeColorProvider
    }

    public func makeTrendingFactory() -> some PopcornTrendingFactory {
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

        return LivePopcornTrendingFactory(
            trendingRemoteDataSource: trendingRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoProvider,
            themeColorProvider: themeColorProvider
        )
    }

}
