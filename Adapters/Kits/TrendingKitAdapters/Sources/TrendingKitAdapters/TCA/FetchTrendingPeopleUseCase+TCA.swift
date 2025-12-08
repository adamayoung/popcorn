//
//  FetchTrendingPeopleUseCase+TCA.swift
//  TrendingKitAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TMDbAdapters
import TrendingApplication

enum FetchTrendingPeopleUseCaseKey: DependencyKey {

    static var liveValue: any FetchTrendingPeopleUseCase {
        DependencyValues._current
            .trendingFactory
            .makeFetchTrendingPeopleUseCase()
    }

}

extension DependencyValues {

    public var fetchTrendingPeople: any FetchTrendingPeopleUseCase {
        get { self[FetchTrendingPeopleUseCaseKey.self] }
        set { self[FetchTrendingPeopleUseCaseKey.self] = newValue }
    }

}
