//
//  FetchTrendingTVSeriesUseCase+TCA.swift
//  TrendingKitAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TMDbAdapters
import TrendingApplication

enum FetchTrendingTVSeriesUseCaseKey: DependencyKey {

    static var liveValue: any FetchTrendingTVSeriesUseCase {
        DependencyValues._current
            .trendingFactory
            .makeFetchTrendingTVSeriesUseCase()
    }

}

extension DependencyValues {

    public var fetchTrendingTVSeries: any FetchTrendingTVSeriesUseCase {
        get { self[FetchTrendingTVSeriesUseCaseKey.self] }
        set { self[FetchTrendingTVSeriesUseCaseKey.self] = newValue }
    }

}
