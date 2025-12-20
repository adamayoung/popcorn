//
//  FetchTVSeriesImageCollectionUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVSeriesImageCollectionUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesImageCollectionUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

}

public extension DependencyValues {

    var fetchTVSeriesImageCollection: any FetchTVSeriesImageCollectionUseCase {
        get { self[FetchTVSeriesImageCollectionUseCaseKey.self] }
        set { self[FetchTVSeriesImageCollectionUseCaseKey.self] = newValue }
    }

}
