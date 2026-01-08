//
//  PopcornTVSeriesAdaptersFactory.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import Foundation
import TMDb
import TVSeriesComposition

public final class PopcornTVSeriesAdaptersFactory {

    private let tvSeriesService: any TVSeriesService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        tvSeriesService: some TVSeriesService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.tvSeriesService = tvSeriesService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makeTVSeriesFactory() -> some PopcornTVSeriesFactory {
        let tvSeriesRemoteDataSource = TMDbTVSeriesRemoteDataSource(
            tvSeriesService: tvSeriesService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return LivePopcornTVSeriesFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
