//
//  FetchTrendingPeopleUseCase+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TrendingApplication

enum FetchTrendingPeopleUseCaseKey: DependencyKey {

    static var liveValue: any FetchTrendingPeopleUseCase {
        @Dependency(\.trendingFactory) var trendingFactory
        return trendingFactory.makeFetchTrendingPeopleUseCase()
    }

}

public extension DependencyValues {

    var fetchTrendingPeople: any FetchTrendingPeopleUseCase {
        get { self[FetchTrendingPeopleUseCaseKey.self] }
        set { self[FetchTrendingPeopleUseCaseKey.self] = newValue }
    }

}
