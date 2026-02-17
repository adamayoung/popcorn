//
//  TVSeriesApplicationFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public final class TVSeriesApplicationFactory: Sendable {

    private let tvSeriesRepository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    public init(
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
    -> some FetchTVSeriesImageCollectionUseCase {
        DefaultFetchTVSeriesImageCollectionUseCase(
            repository: tvSeriesRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
