//
//  FetchTrendingTVSeriesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
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

    ///
    /// A use case for fetching a list of trending TV series.
    ///
    /// Retrieves TV series that are currently trending based on recent
    /// user activity and engagement.
    ///
    var fetchTrendingTVSeries: any FetchTrendingTVSeriesUseCase {
        get { self[FetchTrendingTVSeriesUseCaseKey.self] }
        set { self[FetchTrendingTVSeriesUseCaseKey.self] = newValue }
    }

}
