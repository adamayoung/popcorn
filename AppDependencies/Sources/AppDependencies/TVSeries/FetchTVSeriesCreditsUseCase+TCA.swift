//
//  FetchTVSeriesCreditsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVSeriesCreditsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesCreditsUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVSeriesCreditsUseCase()
    }

}

public extension DependencyValues {

    var fetchTVSeriesCredits: any FetchTVSeriesCreditsUseCase {
        get { self[FetchTVSeriesCreditsUseCaseKey.self] }
        set { self[FetchTVSeriesCreditsUseCaseKey.self] = newValue }
    }

}
