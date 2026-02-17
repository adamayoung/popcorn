//
//  LivePopcornTrendingFactory.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingApplication
import TrendingDomain
import TrendingInfrastructure

public final class LivePopcornTrendingFactory: PopcornTrendingFactory {

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

    public func makeFetchTrendingMoviesUseCase() -> FetchTrendingMoviesUseCase {
        applicationFactory.makeFetchTrendingMoviesUseCase()
    }

    public func makeFetchTrendingTVSeriesUseCase() -> FetchTrendingTVSeriesUseCase {
        applicationFactory.makeFetchTrendingTVSeriesUseCase()
    }

    public func makeFetchTrendingPeopleUseCase() -> FetchTrendingPeopleUseCase {
        applicationFactory.makeFetchTrendingPeopleUseCase()
    }

}
