//
//  TVApplicationFactory.swift
//  TVKit
//
//  Created by Adam Young on 15/10/2025.
//

import Foundation
import TVDomain

public final class TVApplicationFactory {

    private let tvSeriesRepository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        tvSeriesRepository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.tvSeriesRepository = tvSeriesRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    public func makeFetchTVSeriesDetailsUseCase() -> some FetchTVSeriesDetailsUseCase {
        DefaultFetchTVSeriesDetailsUseCase(
            repository: tvSeriesRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchTVSeriesImageCollectionUseCase()
        -> some FetchTVSeriesImageCollectionUseCase
    {
        DefaultFetchTVSeriesImageCollectionUseCase(
            repository: tvSeriesRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
