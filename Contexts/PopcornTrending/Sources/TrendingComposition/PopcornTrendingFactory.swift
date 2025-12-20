//
//  PopcornTrendingFactory.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingApplication
import TrendingDomain
import TrendingInfrastructure

public struct PopcornTrendingFactory {

    private let applicationFactory: TrendingApplicationFactory

    public init(
        trendingRemoteDataSource: some TrendingRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        let infrastructureFactory = TrendingInfrastructureFactory(
            trendingRemoteDataSource: trendingRemoteDataSource
        )
        self.applicationFactory = TrendingApplicationFactory(
            trendingRepository: infrastructureFactory.makeTrendingRepository(),
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider
        )
    }

    public func makeFetchTrendingMoviesUseCase() -> some FetchTrendingMoviesUseCase {
        applicationFactory.makeFetchTrendingMoviesUseCase()
    }

    public func makeFetchTrendingTVSeriesUseCase() -> some FetchTrendingTVSeriesUseCase {
        applicationFactory.makeFetchTrendingTVSeriesUseCase()
    }

    public func makeFetchTrendingPeopleUseCase() -> some FetchTrendingPeopleUseCase {
        applicationFactory.makeFetchTrendingPeopleUseCase()
    }

}
