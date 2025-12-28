//
//  FetchTrendingMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
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

    ///
    /// A use case for fetching a list of trending movies.
    ///
    /// Retrieves movies that are currently trending based on recent
    /// user activity and engagement.
    ///
    var fetchTrendingMovies: any FetchTrendingMoviesUseCase {
        get { self[FetchTrendingMoviesUseCaseKey.self] }
        set { self[FetchTrendingMoviesUseCaseKey.self] = newValue }
    }

}
