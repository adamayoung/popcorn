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

    ///
    /// A use case for fetching a collection of images for a specific TV series.
    ///
    /// Retrieves posters, backdrops, and logo images associated with a TV series.
    ///
    var fetchTVSeriesImageCollection: any FetchTVSeriesImageCollectionUseCase {
        get { self[FetchTVSeriesImageCollectionUseCaseKey.self] }
        set { self[FetchTVSeriesImageCollectionUseCaseKey.self] = newValue }
    }

}
