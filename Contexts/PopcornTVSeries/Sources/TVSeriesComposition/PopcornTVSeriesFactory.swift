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

///
/// Factory for creating TV series use cases and dependencies.
///
/// This is the main entry point for the PopcornTVSeries module. It composes
/// the domain, application, and infrastructure layers to provide fully-configured
/// use cases for fetching TV series data.
///
public struct PopcornTVSeriesFactory {

    private let applicationFactory: TVSeriesApplicationFactory

    ///
    /// Creates a new TV series factory.
    ///
    /// - Parameters:
    ///   - tvSeriesRemoteDataSource: The data source for fetching TV series from a remote API.
    ///   - appConfigurationProvider: The provider for application configuration.
    ///
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

    ///
    /// Creates a use case for fetching TV series details.
    ///
    /// - Returns: A configured ``FetchTVSeriesDetailsUseCase`` instance.
    ///
    public func makeFetchTVSeriesDetailsUseCase() -> some FetchTVSeriesDetailsUseCase {
        applicationFactory.makeFetchTVSeriesDetailsUseCase()
    }

    ///
    /// Creates a use case for fetching TV series image collections.
    ///
    /// - Returns: A configured ``FetchTVSeriesImageCollectionUseCase`` instance.
    ///
    public func makeFetchTVSeriesImageCollectionUseCase()
    -> some FetchTVSeriesImageCollectionUseCase {
        applicationFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

}
