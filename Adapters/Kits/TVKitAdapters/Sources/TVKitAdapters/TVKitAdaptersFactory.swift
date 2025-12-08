//
//  TVKitAdaptersFactory.swift
//  TVKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ConfigurationApplication
import Foundation
import TMDb
import TVApplication

struct TVKitAdaptersFactory {

    let tvSeriesService: any TVSeriesService
    let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    func makeTVFactory() -> TVApplicationFactory {
        let tvSeriesRemoteDataSource = TMDbTVSeriesRemoteDataSource(
            tvSeriesService: tvSeriesService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return TVComposition.makeTVFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
