//
//  LivePopcornTVSeriesFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication
import TVSeriesDomain
import TVSeriesInfrastructure

public final class LivePopcornTVSeriesFactory: PopcornTVSeriesFactory {

    private let applicationFactory: TVSeriesApplicationFactory

    public init(
        tvSeriesRemoteDataSource: some TVSeriesRemoteDataSource,
        tvSeasonRemoteDataSource: some TVSeasonRemoteDataSource,
        tvEpisodeRemoteDataSource: some TVEpisodeRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        let infrastructureFactory = TVSeriesInfrastructureFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            tvSeasonRemoteDataSource: tvSeasonRemoteDataSource,
            tvEpisodeRemoteDataSource: tvEpisodeRemoteDataSource
        )

        self.applicationFactory = TVSeriesApplicationFactory(
            tvSeriesRepository: infrastructureFactory.makeTVSeriesRepository(),
            tvSeasonRepository: infrastructureFactory.makeTVSeasonRepository(),
            tvEpisodeRepository: infrastructureFactory.makeTVEpisodeRepository(),
            tvSeriesCreditsRepository: infrastructureFactory.makeTVSeriesCreditsRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchTVSeriesDetailsUseCase() -> FetchTVSeriesDetailsUseCase {
        applicationFactory.makeFetchTVSeriesDetailsUseCase()
    }

    public func makeFetchTVSeriesImageCollectionUseCase() -> FetchTVSeriesImageCollectionUseCase {
        applicationFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

    public func makeFetchTVSeasonDetailsUseCase() -> FetchTVSeasonDetailsUseCase {
        applicationFactory.makeFetchTVSeasonDetailsUseCase()
    }

    public func makeFetchTVEpisodeDetailsUseCase() -> FetchTVEpisodeDetailsUseCase {
        applicationFactory.makeFetchTVEpisodeDetailsUseCase()
    }

    public func makeFetchTVSeriesCreditsUseCase() -> FetchTVSeriesCreditsUseCase {
        applicationFactory.makeFetchTVSeriesCreditsUseCase()
    }

}
