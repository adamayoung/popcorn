//
//  LivePopcornTrendingFactory.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
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
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        let infrastructureFactory = TrendingInfrastructureFactory(
            trendingRemoteDataSource: trendingRemoteDataSource
        )
        self.applicationFactory = TrendingApplicationFactory(
            trendingRepository: infrastructureFactory.makeTrendingRepository(),
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider,
            themeColorProvider: themeColorProvider
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
