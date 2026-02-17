//
//  FetchTrendingMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TrendingApplication

enum FetchTrendingMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchTrendingMoviesUseCase {
        @Dependency(\.trendingFactory) var trendingFactory
        return trendingFactory.makeFetchTrendingMoviesUseCase()
    }

}

public extension DependencyValues {

    var fetchTrendingMovies: any FetchTrendingMoviesUseCase {
        get { self[FetchTrendingMoviesUseCaseKey.self] }
        set { self[FetchTrendingMoviesUseCaseKey.self] = newValue }
    }

}
