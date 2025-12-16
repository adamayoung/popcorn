//
//  FetchTVSeriesImageCollectionUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
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

extension DependencyValues {

    public var fetchTVSeriesImageCollection: any FetchTVSeriesImageCollectionUseCase {
        get { self[FetchTVSeriesImageCollectionUseCaseKey.self] }
        set { self[FetchTVSeriesImageCollectionUseCaseKey.self] = newValue }
    }

}
