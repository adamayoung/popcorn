//
//  LivePopcornDiscoverFactory.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverApplication
import DiscoverDomain
import DiscoverInfrastructure
import Foundation

public final class LivePopcornDiscoverFactory: PopcornDiscoverFactory {

    private let applicationFactory: DiscoverApplicationFactory

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

    public func makeFetchDiscoverMoviesUseCase() -> FetchDiscoverMoviesUseCase {
        applicationFactory.makeFetchDiscoverMoviesUseCase()
    }

    public func makeFetchDiscoverTVSeriesUseCase() -> FetchDiscoverTVSeriesUseCase {
        applicationFactory.makeFetchDiscoverTVSeriesUseCase()
    }

}
