//
//  FetchTVSeriesDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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
