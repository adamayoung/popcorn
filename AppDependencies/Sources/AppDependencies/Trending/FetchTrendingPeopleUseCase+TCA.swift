//
//  FetchTrendingPeopleUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 18/11/2025.
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

extension DependencyValues {

    public var fetchTrendingPeople: any FetchTrendingPeopleUseCase {
        get { self[FetchTrendingPeopleUseCaseKey.self] }
        set { self[FetchTrendingPeopleUseCaseKey.self] = newValue }
    }

}
