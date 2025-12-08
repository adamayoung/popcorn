//
//  TVComposition.swift
//  PopcornTV
//
//  Created by Adam Young on 20/11/2025.
//

import Foundation
import TVDomain
import TVInfrastructure

public struct TVComposition {

    private init() {}

    public static func makeTVFactory(
        tvSeriesRemoteDataSource: some TVSeriesRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) -> TVApplicationFactory {
        let infrastructureFactory = TVInfrastructureFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource
        )
        let tvSeriesRepository = infrastructureFactory.makeTVSeriesRepository()

        return TVApplicationFactory(
            tvSeriesRepository: tvSeriesRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
