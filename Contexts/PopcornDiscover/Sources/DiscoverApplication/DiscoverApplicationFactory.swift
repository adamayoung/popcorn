//
//  DiscoverApplicationFactory.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

package final class DiscoverApplicationFactory: Sendable {

    private let discoverMovieRepository: any DiscoverMovieRepository
    private let discoverTVSeriesRepository: any DiscoverTVSeriesRepository
    private let genreProvider: any GenreProviding
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    package init(
        discoverMovieRepository: some DiscoverMovieRepository,
        discoverTVSeriesRepository: some DiscoverTVSeriesRepository,
        genreProvider: some GenreProviding,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.discoverMovieRepository = discoverMovieRepository
        self.discoverTVSeriesRepository = discoverTVSeriesRepository
        self.genreProvider = genreProvider
        self.appConfigurationProvider = appConfigurationProvider
        self.movieLogoImageProvider = movieLogoImageProvider
        self.tvSeriesLogoImageProvider = tvSeriesLogoImageProvider
        self.themeColorProvider = themeColorProvider
    }

    package func makeFetchDiscoverMoviesUseCase() -> some FetchDiscoverMoviesUseCase {
        DefaultFetchDiscoverMoviesUseCase(
            repository: discoverMovieRepository,
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: movieLogoImageProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeFetchDiscoverTVSeriesUseCase() -> some FetchDiscoverTVSeriesUseCase {
        DefaultFetchDiscoverTVSeriesUseCase(
            repository: discoverTVSeriesRepository,
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: tvSeriesLogoImageProvider,
            themeColorProvider: themeColorProvider
        )
    }

}
