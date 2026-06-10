//
//  PopcornTVSeriesAdaptersFactory.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import TMDb
import TVSeriesDomain
import TVSeriesInfrastructure

/// Builds the TV Series context's TMDb-backed adapters (port implementations).
public final class PopcornTVSeriesAdaptersFactory {

    private let tvSeriesService: any TMDb.TVSeriesService
    private let tvSeasonService: any TMDb.TVSeasonService
    private let tvEpisodeService: any TMDb.TVEpisodeService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        tvSeriesService: some TMDb.TVSeriesService,
        tvSeasonService: some TMDb.TVSeasonService,
        tvEpisodeService: some TMDb.TVEpisodeService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.tvSeriesService = tvSeriesService
        self.tvSeasonService = tvSeasonService
        self.tvEpisodeService = tvEpisodeService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makeTVSeriesRemoteDataSource() -> some TVSeriesRemoteDataSource {
        TMDbTVSeriesRemoteDataSource(tvSeriesService: tvSeriesService)
    }

    public func makeTVSeasonRemoteDataSource() -> some TVSeasonRemoteDataSource {
        TMDbTVSeasonRemoteDataSource(tvSeasonService: tvSeasonService)
    }

    public func makeTVEpisodeRemoteDataSource() -> some TVEpisodeRemoteDataSource {
        TMDbTVEpisodeRemoteDataSource(tvEpisodeService: tvEpisodeService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

}
