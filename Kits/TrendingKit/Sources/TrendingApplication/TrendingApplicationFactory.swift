//
//  TrendingApplicationFactory.swift
//  TrendingKit
//
//  Created by Adam Young on 15/10/2025.
//

import Foundation
import TrendingDomain

public final class TrendingApplicationFactory {

    private let trendingRepository: any TrendingRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding

    init(
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

    public func makeFetchTrendingMoviesUseCase() -> some FetchTrendingMoviesUseCase {
        DefaultFetchTrendingMoviesUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider
        )
    }

    public func makeFetchTrendingTVSeriesUseCase() -> some FetchTrendingTVSeriesUseCase {
        DefaultFetchTrendingTVSeriesUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchTrendingPeopleUseCase() -> some FetchTrendingPeopleUseCase {
        DefaultFetchTrendingPeopleUseCase(
            repository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
