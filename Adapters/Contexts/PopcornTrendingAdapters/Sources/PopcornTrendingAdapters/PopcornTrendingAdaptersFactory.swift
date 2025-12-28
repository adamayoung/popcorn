//
//  PopcornTrendingAdaptersFactory.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import Foundation
import MoviesApplication
import TMDb
import TrendingComposition
import TVSeriesApplication

///
/// A factory for creating trending-related adapters.
///
/// Creates adapters that bridge TMDb trending services and various use cases
/// to the application's trending domain.
///
public final class PopcornTrendingAdaptersFactory {

    private let trendingService: any TrendingService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    ///
    /// Creates a trending adapters factory.
    ///
    /// - Parameters:
    ///   - trendingService: The TMDb trending service.
    ///   - fetchAppConfigurationUseCase: The use case for fetching app configuration.
    ///   - fetchMovieImageCollectionUseCase: The use case for fetching movie image collections.
    ///   - fetchTVSeriesImageCollectionUseCase: The use case for fetching TV series image collections.
    ///
    public init(
        trendingService: some TrendingService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieImageCollectionUseCase: some FetchMovieImageCollectionUseCase,
        fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase
    ) {
        self.trendingService = trendingService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieImageCollectionUseCase = fetchMovieImageCollectionUseCase
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
    }

    ///
    /// Creates a trending factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornTrendingFactory`` instance.
    ///
    public func makeTrendingFactory() -> PopcornTrendingFactory {
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

        return PopcornTrendingFactory(
            trendingRemoteDataSource: trendingRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoProvider
        )
    }

}
