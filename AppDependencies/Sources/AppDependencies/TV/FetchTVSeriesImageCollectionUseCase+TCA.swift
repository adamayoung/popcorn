//
//  FetchTVSeriesImageCollectionUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import TVApplication

enum FetchTVSeriesImageCollectionUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesImageCollectionUseCase {
        @Dependency(\.tvFactory) var tvFactory
        return tvFactory.makeFetchTVSeriesImageCollectionUseCase()
    }

}

extension DependencyValues {

    public var fetchTVSeriesImageCollection: any FetchTVSeriesImageCollectionUseCase {
        get { self[FetchTVSeriesImageCollectionUseCaseKey.self] }
        set { self[FetchTVSeriesImageCollectionUseCaseKey.self] = newValue }
    }

}
