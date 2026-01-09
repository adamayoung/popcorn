//
//  UITestPopcornTrendingFactory.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingApplication
import TrendingComposition
import TrendingDomain

public final class UITestPopcornTrendingFactory: PopcornTrendingFactory {

    private let applicationFactory: TrendingApplicationFactory

    public init() {
        self.applicationFactory = TrendingApplicationFactory(
            trendingRepository: StubTrendingRepository(),
            appConfigurationProvider: StubAppConfigurationProvider(),
            movieLogoImageProvider: StubMovieLogoImageProvider(),
            tvSeriesLogoImageProvider: StubTVSeriesLogoImageProvider()
        )
    }

    public func makeFetchTrendingMoviesUseCase() -> FetchTrendingMoviesUseCase {
        applicationFactory.makeFetchTrendingMoviesUseCase()
    }

    public func makeFetchTrendingTVSeriesUseCase() -> FetchTrendingTVSeriesUseCase {
        applicationFactory.makeFetchTrendingTVSeriesUseCase()
    }

    public func makeFetchTrendingPeopleUseCase() -> FetchTrendingPeopleUseCase {
        applicationFactory.makeFetchTrendingPeopleUseCase()
    }

}
