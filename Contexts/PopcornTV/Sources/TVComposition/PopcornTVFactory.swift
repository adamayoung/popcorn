//
//  PopcornTVFactory.swift
//  PopcornTV
//
//  Created by Adam Young on 15/12/2025.
//

import Foundation
import TVApplication
import TVDomain
import TVInfrastructure

public struct PopcornTVFactory {

    private let applicationFactory: TVApplicationFactory

    public init(
        tvSeriesRemoteDataSource: some TVSeriesRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        let infrastructureFactory = TVInfrastructureFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource
        )

        self.applicationFactory = TVApplicationFactory(
            tvSeriesRepository: infrastructureFactory.makeTVSeriesRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchTVSeriesDetailsUseCase() -> some FetchTVSeriesDetailsUseCase {
        applicationFactory.makeFetchTVSeriesDetailsUseCase()
    }

    public func makeFetchTVSeriesImageCollectionUseCase()
        -> some FetchTVSeriesImageCollectionUseCase
    {
        applicationFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

}
