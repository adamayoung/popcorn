//
//  DiscoverComposition.swift
//  PopcornDiscover
//
//  Created by Adam Young on 20/11/2025.
//

import DiscoverDomain
import DiscoverInfrastructure
import Foundation

public struct DiscoverComposition {

    private init() {}

    public static func makeDiscoverFactory(
        discoverRemoteDataSource: some DiscoverRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        genreProvider: some GenreProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) -> DiscoverApplicationFactory {
        let infrastructureFactory = DiscoverInfrastructureFactory(
            discoverRemoteDataSource: discoverRemoteDataSource
        )
        let discoverMovieRepository = infrastructureFactory.makeDiscoverMovieRepository()
        let discoverTVSeriesRepository = infrastructureFactory.makeDiscoverTVSeriesRepository()

        return DiscoverApplicationFactory(
            discoverMovieRepository: discoverMovieRepository,
            discoverTVSeriesRepository: discoverTVSeriesRepository,
            genreProvider: genreProvider,
            appConfigurationProvider: appConfigurationProvider,
            movieLogoImageProvider: movieLogoImageProvider,
            tvSeriesLogoImageProvider: tvSeriesLogoImageProvider
        )
    }

}
