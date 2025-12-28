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

///
/// A factory for creating TV series-related adapters.
///
/// Creates adapters that bridge TMDb TV series services to the application's
/// TV series domain.
///
public final class PopcornTVSeriesAdaptersFactory {

    private let tvSeriesService: any TVSeriesService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    ///
    /// Creates a TV series adapters factory.
    ///
    /// - Parameters:
    ///   - tvSeriesService: The TMDb TV series service.
    ///   - fetchAppConfigurationUseCase: The use case for fetching app configuration.
    ///
    public init(
        tvSeriesService: some TVSeriesService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.tvSeriesService = tvSeriesService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    ///
    /// Creates a TV series factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornTVSeriesFactory`` instance.
    ///
    public func makeTVSeriesFactory() -> PopcornTVSeriesFactory {
        let tvSeriesRemoteDataSource = TMDbTVSeriesRemoteDataSource(
            tvSeriesService: tvSeriesService
        )

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return PopcornTVSeriesFactory(
            tvSeriesRemoteDataSource: tvSeriesRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
