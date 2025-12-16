//
//  FetchTrendingTVSeriesUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 18/11/2025.
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

extension DependencyValues {

    public var fetchTrendingTVSeries: any FetchTrendingTVSeriesUseCase {
        get { self[FetchTrendingTVSeriesUseCaseKey.self] }
        set { self[FetchTrendingTVSeriesUseCaseKey.self] = newValue }
    }

}
