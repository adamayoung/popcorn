//
//  PopcornSearchAdaptersFactory.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import Foundation
import MoviesApplication
import PeopleApplication
import PopcornMoviesAdapters
import PopcornPeopleAdapters
import PopcornTVSeriesAdapters
import SearchComposition
import TMDb
import TVSeriesApplication

///
/// A factory for creating search-related adapters.
///
/// Creates adapters that bridge TMDb search services and various use cases
/// to the application's search domain.
///
public final class PopcornSearchAdaptersFactory {

    private let searchService: any SearchService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase
    private let fetchPersonDetailsUseCase: any FetchPersonDetailsUseCase

    ///
    /// Creates a search adapters factory.
    ///
    /// - Parameters:
    ///   - searchService: The TMDb search service.
    ///   - fetchAppConfigurationUseCase: The use case for fetching app configuration.
    ///   - fetchMovieDetailsUseCase: The use case for fetching movie details.
    ///   - fetchTVSeriesDetailsUseCase: The use case for fetching TV series details.
    ///   - fetchPersonDetailsUseCase: The use case for fetching person details.
    ///
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

    ///
    /// Creates a search factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornSearchFactory`` instance.
    ///
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
