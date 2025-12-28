//
//  PopcornDiscoverFactory.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverApplication
import DiscoverDomain
import DiscoverInfrastructure
import Foundation

///
/// Factory for creating discover feature use cases.
///
/// This factory serves as the main entry point for the PopcornDiscover module,
/// providing configured use cases for discovering movies and TV series.
///
public final class PopcornDiscoverFactory {

    private let applicationFactory: DiscoverApplicationFactory

    ///
    /// Creates a new factory with the required dependencies.
    ///
    /// - Parameters:
    ///   - discoverRemoteDataSource: The remote data source for fetching discover content.
    ///   - appConfigurationProvider: Provider for application configuration including image URLs.
    ///   - genreProvider: Provider for movie and TV series genre information.
    ///   - movieLogoImageProvider: Provider for movie logo images.
    ///   - tvSeriesLogoImageProvider: Provider for TV series logo images.
    ///
    public init(
        discoverRemoteDataSource: some DiscoverRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        genreProvider: some GenreProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        let infrastructureFactory = DiscoverInfrastructureFactory(
            discoverRemoteDataSource: discoverRemoteDataSource
        )
        self.applicationFactory = DiscoverApplicationFactory(
            discoverMovieRepository: infrastructureFactory.makeDiscoverMovieRepository(),
            discoverTVSeriesRepository: infrastructureFactory.makeDiscoverTVSeriesRepository(),
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider
        )
    }

    ///
    /// Creates a use case for fetching discoverable movies.
    ///
    /// - Returns: A configured ``FetchDiscoverMoviesUseCase`` instance.
    ///
    public func makeFetchDiscoverMoviesUseCase() -> some FetchDiscoverMoviesUseCase {
        applicationFactory.makeFetchDiscoverMoviesUseCase()
    }

    ///
    /// Creates a use case for fetching discoverable TV series.
    ///
    /// - Returns: A configured ``FetchDiscoverTVSeriesUseCase`` instance.
    ///
    public func makeFetchDiscoverTVSeriesUseCase() -> some FetchDiscoverTVSeriesUseCase {
        applicationFactory.makeFetchDiscoverTVSeriesUseCase()
    }

}
