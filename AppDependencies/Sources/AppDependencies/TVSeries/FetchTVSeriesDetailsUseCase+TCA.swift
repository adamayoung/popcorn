//
//  FetchTVSeriesDetailsUseCase+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVSeriesDetailsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesDetailsUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVSeriesDetailsUseCase()
    }

}

public extension DependencyValues {

    var fetchTVSeriesDetails: any FetchTVSeriesDetailsUseCase {
        get { self[FetchTVSeriesDetailsUseCaseKey.self] }
        set { self[FetchTVSeriesDetailsUseCaseKey.self] = newValue }
    }

}
