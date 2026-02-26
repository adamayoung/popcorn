//
//  FetchTVSeriesAggregateCreditsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVSeriesAggregateCreditsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesAggregateCreditsUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVSeriesAggregateCreditsUseCase()
    }

}

public extension DependencyValues {

    var fetchTVSeriesAggregateCredits: any FetchTVSeriesAggregateCreditsUseCase {
        get { self[FetchTVSeriesAggregateCreditsUseCaseKey.self] }
        set { self[FetchTVSeriesAggregateCreditsUseCaseKey.self] = newValue }
    }

}
