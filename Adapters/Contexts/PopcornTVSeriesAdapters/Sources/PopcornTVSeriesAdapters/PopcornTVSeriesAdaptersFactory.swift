//
//  PopcornTVSeriesAdaptersFactory.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Foundation
import TMDb
import TVSeriesComposition

public final class PopcornTVSeriesAdaptersFactory {

    private let tvSeriesService: any TVSeriesService
    private let tvSeasonService: any TVSeasonService
    private let tvEpisodeService: any TVEpisodeService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let themeColorProvider: (any ThemeColorProviding)?

    public init(
        tvSeriesService: some TVSeriesService,
        tvSeasonService: some TVSeasonService,
        tvEpisodeService: some TVEpisodeService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.tvSeriesService = tvSeriesService
        self.tvSeasonService = tvSeasonService
        self.tvEpisodeService = tvEpisodeService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.themeColorProvider = themeColorProvider
    }

    public func makeTVSeriesFactory() -> some PopcornTVSeriesFactory {
        let tvSeriesRemoteDataSource = TMDbTVSeriesRemoteDataSource(
            tvSeriesService: tvSeriesService
        )

        let tvSeasonRemoteDataSource = TMDbTVSeasonRemoteDataSource(
            tvSeasonService: tvSeasonService
        )

        let tvEpisodeRemoteDataSource = TMDbTVEpisodeRemoteDataSource(
            tvEpisodeService: tvEpisodeService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return LivePopcornTVSeriesFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            tvSeasonRemoteDataSource: tvSeasonRemoteDataSource,
            tvEpisodeRemoteDataSource: tvEpisodeRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

}
