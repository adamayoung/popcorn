//
//  PopcornTVSeriesFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesApplication
import TVSeriesDomain
import TVSeriesInfrastructure

public struct PopcornTVSeriesFactory {

    private let applicationFactory: TVSeriesApplicationFactory

    public init(
        tvSeriesRemoteDataSource: some TVSeriesRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        let infrastructureFactory = TVSeriesInfrastructureFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource
        )

        self.applicationFactory = TVSeriesApplicationFactory(
            tvSeriesRepository: infrastructureFactory.makeTVSeriesRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchTVSeriesDetailsUseCase() -> some FetchTVSeriesDetailsUseCase {
        applicationFactory.makeFetchTVSeriesDetailsUseCase()
    }

    public func makeFetchTVSeriesImageCollectionUseCase()
    -> some FetchTVSeriesImageCollectionUseCase {
        applicationFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

}
