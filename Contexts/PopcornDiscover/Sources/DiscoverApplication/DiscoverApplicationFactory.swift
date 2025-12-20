//
//  DiscoverApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

package final class DiscoverApplicationFactory {

    private let discoverMovieRepository: any DiscoverMovieRepository
    private let discoverTVSeriesRepository: any DiscoverTVSeriesRepository
    private let genreProvider: any GenreProviding
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding

    package init(
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

    package func makeFetchDiscoverMoviesUseCase() -> some FetchDiscoverMoviesUseCase {
        DefaultFetchDiscoverMoviesUseCase(
            repository: discoverMovieRepository,
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: movieLogoImageProvider
        )
    }

    package func makeFetchDiscoverTVSeriesUseCase() -> some FetchDiscoverTVSeriesUseCase {
        DefaultFetchDiscoverTVSeriesUseCase(
            repository: discoverTVSeriesRepository,
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: tvSeriesLogoImageProvider
        )
    }

}
