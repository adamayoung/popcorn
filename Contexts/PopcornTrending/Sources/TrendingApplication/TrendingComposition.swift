//
//  TrendingComposition.swift
//  PopcornTrending
//
//  Created by Adam Young on 20/11/2025.
//

import Foundation
import TrendingDomain
import TrendingInfrastructure

public struct TrendingComposition {

    private init() {}

    public static func makeTrendingFactory(
        trendingRemoteDataSource: some TrendingRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) -> TrendingApplicationFactory {
        let infrastructureFactory = TrendingInfrastructureFactory(
            trendingRemoteDataSource: trendingRemoteDataSource
        )
        let trendingRepository = infrastructureFactory.makeTrendingRepository()

        return TrendingApplicationFactory(
            trendingRepository: trendingRepository,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider
        )
    }

}
