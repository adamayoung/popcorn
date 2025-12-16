//
//  PopcornTVAdaptersFactory.swift
//  PopcornTVAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ConfigurationApplication
import Foundation
import TMDb
import TVComposition

public final class PopcornTVAdaptersFactory {

    private let tvSeriesService: any TVSeriesService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        tvSeriesService: some TVSeriesService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.tvSeriesService = tvSeriesService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makeTVFactory() -> PopcornTVFactory {
        let tvSeriesRemoteDataSource = TMDbTVSeriesRemoteDataSource(
            tvSeriesService: tvSeriesService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return PopcornTVFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
