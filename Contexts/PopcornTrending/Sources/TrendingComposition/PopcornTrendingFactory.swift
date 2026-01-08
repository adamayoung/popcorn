//
//  PopcornTrendingFactory.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingApplication

public protocol PopcornTrendingFactory: Sendable {

    func makeFetchTrendingMoviesUseCase() -> FetchTrendingMoviesUseCase

    func makeFetchTrendingTVSeriesUseCase() -> FetchTrendingTVSeriesUseCase

    func makeFetchTrendingPeopleUseCase() -> FetchTrendingPeopleUseCase

}
