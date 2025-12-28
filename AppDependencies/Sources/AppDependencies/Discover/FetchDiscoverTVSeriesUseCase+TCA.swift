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

    ///
    /// A use case for fetching discoverable TV series.
    ///
    /// Retrieves a curated list of TV series based on discovery filters such as
    /// genre, first air date, and popularity.
    ///
    var fetchDiscoverTVSeries: any FetchDiscoverTVSeriesUseCase {
        get { self[FetchDiscoverTVSeriesUseCaseKey.self] }
        set { self[FetchDiscoverTVSeriesUseCaseKey.self] = newValue }
    }

}
