//
//  FetchTVSeriesDetailsUseCase+TCA.swift
//  AppDependencies
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

    ///
    /// A use case for fetching detailed information about a specific TV series.
    ///
    /// Retrieves comprehensive details for a TV series including cast, crew,
    /// seasons, and other metadata.
    ///
    var fetchTVSeriesDetails: any FetchTVSeriesDetailsUseCase {
        get { self[FetchTVSeriesDetailsUseCaseKey.self] }
        set { self[FetchTVSeriesDetailsUseCaseKey.self] = newValue }
    }

}
