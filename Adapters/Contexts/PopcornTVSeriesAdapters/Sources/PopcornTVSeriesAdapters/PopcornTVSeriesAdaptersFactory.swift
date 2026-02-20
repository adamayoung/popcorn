//
//  PopcornTVSeriesAdaptersFactory.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import Foundation
import TMDb
import TVSeriesComposition

public final class PopcornTVSeriesAdaptersFactory {

    private let tvSeriesService: any TVSeriesService
    private let tvSeasonService: any TVSeasonService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        tvSeriesService: some TVSeriesService,
        tvSeasonService: some TVSeasonService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.tvSeriesService = tvSeriesService
        self.tvSeasonService = tvSeasonService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makeTVSeriesFactory() -> some PopcornTVSeriesFactory {
        let tvSeriesRemoteDataSource = TMDbTVSeriesRemoteDataSource(
            tvSeriesService: tvSeriesService
        )

        let tvSeasonRemoteDataSource = TMDbTVSeasonRemoteDataSource(
            tvSeasonService: tvSeasonService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return LivePopcornTVSeriesFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            tvSeasonRemoteDataSource: tvSeasonRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
