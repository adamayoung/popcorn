//
//  TrendingApplicationFactory.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingDomain

package final class TrendingApplicationFactory: Sendable {

    private let trendingRepository: any TrendingRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding

    package init(
        trendingRepository: some TrendingRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        self.trendingRepository = trendingRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.movieLogoImageProvider = movieLogoImageProvider
        self.tvSeriesLogoImageProvider = tvSeriesLogoImageProvider
    }

    package func makeFetchTrendingMoviesUseCase() -> some FetchTrendingMoviesUseCase {
        DefaultFetchTrendingMoviesUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider,
            logoImageProvider: movieLogoImageProvider
        )
    }

    package func makeFetchTrendingTVSeriesUseCase() -> some FetchTrendingTVSeriesUseCase {
        DefaultFetchTrendingTVSeriesUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchTrendingPeopleUseCase() -> some FetchTrendingPeopleUseCase {
        DefaultFetchTrendingPeopleUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
