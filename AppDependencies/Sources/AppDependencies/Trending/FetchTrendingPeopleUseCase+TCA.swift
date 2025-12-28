//
//  FetchTrendingPeopleUseCase+TCA.swift
//  AppDependencies
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

    ///
    /// A use case for fetching a list of trending people.
    ///
    /// Retrieves people (actors, directors, etc.) that are currently trending
    /// based on recent user activity and engagement.
    ///
    var fetchTrendingPeople: any FetchTrendingPeopleUseCase {
        get { self[FetchTrendingPeopleUseCaseKey.self] }
        set { self[FetchTrendingPeopleUseCaseKey.self] = newValue }
    }

}
