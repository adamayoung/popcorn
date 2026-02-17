//
//  FetchTrendingTVSeriesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TrendingApplication

enum FetchTrendingTVSeriesUseCaseKey: DependencyKey {

    static var liveValue: any FetchTrendingTVSeriesUseCase {
        @Dependency(\.trendingFactory) var trendingFactory
        return trendingFactory.makeFetchTrendingTVSeriesUseCase()
    }

}

public extension DependencyValues {

    var fetchTrendingTVSeries: any FetchTrendingTVSeriesUseCase {
        get { self[FetchTrendingTVSeriesUseCaseKey.self] }
        set { self[FetchTrendingTVSeriesUseCaseKey.self] = newValue }
    }

}
