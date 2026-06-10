//
//  PopcornSearchAdaptersFactory.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import MoviesApplication
import PeopleApplication
import PopcornMoviesAdapters
import PopcornPeopleAdapters
import PopcornTVSeriesAdapters
import SearchDomain
import SearchInfrastructure
import TMDb
import TVSeriesApplication

public final class PopcornSearchAdaptersFactory {

    private let searchService: any SearchService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase
    private let fetchPersonDetailsUseCase: any FetchPersonDetailsUseCase

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

    public func makeMediaRemoteDataSource() -> some MediaRemoteDataSource {
        TMDbMediaRemoteDataSource(searchService: searchService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

    public func makeMediaProvider() -> some MediaProviding {
        MediaProviderAdapter(
            fetchMovieUseCase: fetchMovieDetailsUseCase,
            fetchTVSeriesUseCase: fetchTVSeriesDetailsUseCase,
            fetchPersonUseCase: fetchPersonDetailsUseCase
        )
    }

}
