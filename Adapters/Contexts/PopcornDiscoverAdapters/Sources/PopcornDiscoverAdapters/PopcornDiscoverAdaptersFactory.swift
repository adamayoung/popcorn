//
//  PopcornDiscoverAdaptersFactory.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import DiscoverComposition
import Foundation
import GenresApplication
import MoviesApplication
import TMDb
import TVSeriesApplication

///
/// A factory for creating discover-related adapters.
///
/// Creates adapters that bridge TMDb discover services and various use cases
/// to the application's discover domain.
///
public final class PopcornDiscoverAdaptersFactory {

    private let discoverService: any DiscoverService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    private let fetchTVSeriesGenresUseCase: any FetchTVSeriesGenresUseCase
    private let fetchMovieImageCollectionUseCase: any FetchMovieImageCollectionUseCase
    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    ///
    /// Creates a discover adapters factory.
    ///
    /// - Parameters:
    ///   - discoverService: The TMDb discover service.
    ///   - fetchAppConfigurationUseCase: The use case for fetching app configuration.
    ///   - fetchMovieGenresUseCase: The use case for fetching movie genres.
    ///   - fetchTVSeriesGenresUseCase: The use case for fetching TV series genres.
    ///   - fetchMovieImageCollectionUseCase: The use case for fetching movie image collections.
    ///   - fetchTVSeriesImageCollectionUseCase: The use case for fetching TV series image collections.
    ///
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

    ///
    /// Creates a discover factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornDiscoverFactory`` instance.
    ///
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
