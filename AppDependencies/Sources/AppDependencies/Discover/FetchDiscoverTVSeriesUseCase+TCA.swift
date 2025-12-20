//
//  FetchDiscoverTVSeriesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DiscoverApplication
import Foundation

enum FetchDiscoverTVSeriesUseCaseKey: DependencyKey {

    static var liveValue: any FetchDiscoverTVSeriesUseCase {
        @Dependency(\.discoverFactory) var discoverFactory
        return discoverFactory.makeFetchDiscoverTVSeriesUseCase()
    }

}

public extension DependencyValues {

    var fetchDiscoverTVSeries: any FetchDiscoverTVSeriesUseCase {
        get { self[FetchDiscoverTVSeriesUseCaseKey.self] }
        set { self[FetchDiscoverTVSeriesUseCaseKey.self] = newValue }
    }

}
