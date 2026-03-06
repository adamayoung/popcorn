//
//  TrendingApplicationFactory.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

package final class TrendingApplicationFactory: Sendable {

    private let trendingRepository: any TrendingRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    package init(
        trendingRepository: some TrendingRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.trendingRepository = trendingRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.movieLogoImageProvider = movieLogoImageProvider
        self.tvSeriesLogoImageProvider = tvSeriesLogoImageProvider
        self.themeColorProvider = themeColorProvider
    }

    package func makeFetchTrendingMoviesUseCase() -> some FetchTrendingMoviesUseCase {
        DefaultFetchTrendingMoviesUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: movieLogoImageProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeFetchTrendingTVSeriesUseCase() -> some FetchTrendingTVSeriesUseCase {
        DefaultFetchTrendingTVSeriesUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeFetchTrendingPeopleUseCase() -> some FetchTrendingPeopleUseCase {
        DefaultFetchTrendingPeopleUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
