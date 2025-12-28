//
//  PopcornTrendingFactory.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingApplication
import TrendingDomain
import TrendingInfrastructure

///
/// A factory for creating trending module use cases.
///
/// This is the main entry point for the PopcornTrending module. It composes
/// all internal layers (domain, application, infrastructure) and exposes
/// use cases for fetching trending content.
///
public struct PopcornTrendingFactory {

    private let applicationFactory: TrendingApplicationFactory

    ///
    /// Creates a new trending factory instance.
    ///
    /// - Parameters:
    ///   - trendingRemoteDataSource: The data source for fetching trending content from a remote API.
    ///   - appConfigurationProvider: The provider for application configuration data.
    ///   - movieLogoImageProvider: The provider for movie logo images.
    ///   - tvSeriesLogoImageProvider: The provider for TV series logo images.
    ///
    public init(
        trendingRemoteDataSource: some TrendingRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        let infrastructureFactory = TrendingInfrastructureFactory(
            trendingRemoteDataSource: trendingRemoteDataSource
        )
        self.applicationFactory = TrendingApplicationFactory(
            trendingRepository: infrastructureFactory.makeTrendingRepository(),
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider
        )
    }

    ///
    /// Creates a use case for fetching trending movies.
    ///
    /// - Returns: A configured use case instance.
    ///
    public func makeFetchTrendingMoviesUseCase() -> some FetchTrendingMoviesUseCase {
        applicationFactory.makeFetchTrendingMoviesUseCase()
    }

    ///
    /// Creates a use case for fetching trending TV series.
    ///
    /// - Returns: A configured use case instance.
    ///
    public func makeFetchTrendingTVSeriesUseCase() -> some FetchTrendingTVSeriesUseCase {
        applicationFactory.makeFetchTrendingTVSeriesUseCase()
    }

    ///
    /// Creates a use case for fetching trending people.
    ///
    /// - Returns: A configured use case instance.
    ///
    public func makeFetchTrendingPeopleUseCase() -> some FetchTrendingPeopleUseCase {
        applicationFactory.makeFetchTrendingPeopleUseCase()
    }

}
