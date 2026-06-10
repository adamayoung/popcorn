//
//  PopcornTrendingAdaptersFactory.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import MoviesApplication
import TMDb
import TrendingDomain
import TrendingInfrastructure
import TVSeriesApplication

/// Builds the Trending context's TMDb-backed adapters (port implementations).
public final class PopcornTrendingAdaptersFactory {

    private let trendingService: any TMDb.TrendingService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    public init(
        trendingService: some TMDb.TrendingService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieImageCollectionUseCase: some FetchMovieImageCollectionUseCase,
        fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase
    ) {
        self.trendingService = trendingService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieImageCollectionUseCase = fetchMovieImageCollectionUseCase
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
    }

    public func makeTrendingRemoteDataSource() -> some TrendingRemoteDataSource {
        TMDbTrendingRemoteDataSource(trendingService: trendingService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

    public func makeMovieLogoImageProvider() -> some MovieLogoImageProviding {
        MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: fetchMovieImageCollectionUseCase)
    }

    public func makeTVSeriesLogoImageProvider() -> some TVSeriesLogoImageProviding {
        TVSeriesLogoImageProviderAdapter(fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollectionUseCase)
    }

}
