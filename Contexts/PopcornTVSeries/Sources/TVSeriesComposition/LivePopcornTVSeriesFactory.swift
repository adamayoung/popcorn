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
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        let infrastructureFactory = TVSeriesInfrastructureFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            tvSeasonRemoteDataSource: tvSeasonRemoteDataSource
        )

        self.applicationFactory = TVSeriesApplicationFactory(
            tvSeriesRepository: infrastructureFactory.makeTVSeriesRepository(),
            tvSeasonRepository: infrastructureFactory.makeTVSeasonRepository(),
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

}
