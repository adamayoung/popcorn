//
//  FetchDiscoverTVSeriesUseCase+TCA.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import DiscoverApplication
import Foundation

enum FetchDiscoverTVSeriesUseCaseKey: DependencyKey {

    static var liveValue: any FetchDiscoverTVSeriesUseCase {
        DependencyValues._current
            .discoverFactory
            .makeFetchDiscoverTVSeriesUseCase()
    }

}

extension DependencyValues {

    public var fetchDiscoverTVSeries: any FetchDiscoverTVSeriesUseCase {
        get { self[FetchDiscoverTVSeriesUseCaseKey.self] }
        set { self[FetchDiscoverTVSeriesUseCaseKey.self] = newValue }
    }

}
