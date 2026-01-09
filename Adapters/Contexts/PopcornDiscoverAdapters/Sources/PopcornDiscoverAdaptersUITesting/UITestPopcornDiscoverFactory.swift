//
//  UITestPopcornDiscoverFactory.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverApplication
import DiscoverComposition
import DiscoverDomain
import Foundation

public final class UITestPopcornDiscoverFactory: PopcornDiscoverFactory {

    private let applicationFactory: DiscoverApplicationFactory

    public init() {
        self.applicationFactory = DiscoverApplicationFactory(
            discoverMovieRepository: StubDiscoverMovieRepository(),
            discoverTVSeriesRepository: StubDiscoverTVSeriesRepository(),
            genreProvider: StubGenreProvider(),
            appConfigurationProvider: StubAppConfigurationProvider(),
            movieLogoImageProvider: StubMovieLogoImageProvider(),
            tvSeriesLogoImageProvider: StubTVSeriesLogoImageProvider()
        )
    }

    public func makeFetchDiscoverMoviesUseCase() -> FetchDiscoverMoviesUseCase {
        applicationFactory.makeFetchDiscoverMoviesUseCase()
    }

    public func makeFetchDiscoverTVSeriesUseCase() -> FetchDiscoverTVSeriesUseCase {
        applicationFactory.makeFetchDiscoverTVSeriesUseCase()
    }

}
