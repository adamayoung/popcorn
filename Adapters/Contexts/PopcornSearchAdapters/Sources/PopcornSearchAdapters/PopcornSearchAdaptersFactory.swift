//
//  PopcornSearchAdaptersFactory.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Foundation
import MoviesApplication
import PeopleApplication
import PopcornMoviesAdapters
import PopcornPeopleAdapters
import PopcornTVSeriesAdapters
import SearchComposition
import TMDb
import TVSeriesApplication

public final class PopcornSearchAdaptersFactory {

    private let searchService: any SearchService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase
    private let fetchPersonDetailsUseCase: any FetchPersonDetailsUseCase
    private let themeColorProvider: (any ThemeColorProviding)?

    public init(
        searchService: some SearchService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase,
        fetchTVSeriesDetailsUseCase: some FetchTVSeriesDetailsUseCase,
        fetchPersonDetailsUseCase: some FetchPersonDetailsUseCase,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.searchService = searchService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchTVSeriesDetailsUseCase = fetchTVSeriesDetailsUseCase
        self.fetchPersonDetailsUseCase = fetchPersonDetailsUseCase
        self.themeColorProvider = themeColorProvider
    }

    public func makeSearchFactory() -> some PopcornSearchFactory {
        let mediaRemoteDataSource = TMDbMediaRemoteDataSource(searchService: searchService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        let mediaProvider = MediaProviderAdapter(
            fetchMovieUseCase: fetchMovieDetailsUseCase,
            fetchTVSeriesUseCase: fetchTVSeriesDetailsUseCase,
            fetchPersonUseCase: fetchPersonDetailsUseCase
        )

        return LivePopcornSearchFactory(
            mediaRemoteDataSource: mediaRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            mediaProvider: mediaProvider,
            themeColorProvider: themeColorProvider
        )
    }

}
