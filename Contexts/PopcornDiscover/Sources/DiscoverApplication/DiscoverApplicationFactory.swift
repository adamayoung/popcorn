//
//  DiscoverApplicationFactory.swift
//  PopcornDiscover
//
//  Created by Adam Young on 15/10/2025.
//

import DiscoverDomain
import Foundation

public final class DiscoverApplicationFactory {

    private let discoverMovieRepository: any DiscoverMovieRepository
    private let discoverTVSeriesRepository: any DiscoverTVSeriesRepository
    private let genreProvider: any GenreProviding
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding

    init(
        discoverMovieRepository: some DiscoverMovieRepository,
        discoverTVSeriesRepository: some DiscoverTVSeriesRepository,
        genreProvider: some GenreProviding,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        self.discoverMovieRepository = discoverMovieRepository
        self.discoverTVSeriesRepository = discoverTVSeriesRepository
        self.genreProvider = genreProvider
        self.appConfigurationProvider = appConfigurationProvider
        self.movieLogoImageProvider = movieLogoImageProvider
        self.tvSeriesLogoImageProvider = tvSeriesLogoImageProvider
    }

    public func makeFetchDiscoverMoviesUseCase() -> some FetchDiscoverMoviesUseCase {
        DefaultFetchDiscoverMoviesUseCase(
            repository: discoverMovieRepository,
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: movieLogoImageProvider
        )
    }

    public func makeFetchDiscoverTVSeriesUseCase() -> some FetchDiscoverTVSeriesUseCase {
        DefaultFetchDiscoverTVSeriesUseCase(
            repository: discoverTVSeriesRepository,
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: tvSeriesLogoImageProvider
        )
    }

}
