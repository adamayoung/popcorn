//
//  FetchWatchlistMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchWatchlistMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchWatchlistMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchWatchlistMoviesUseCase()
    }

}

public extension DependencyValues {

    var fetchWatchlistMovies: any FetchWatchlistMoviesUseCase {
        get { self[FetchWatchlistMoviesUseCaseKey.self] }
        set { self[FetchWatchlistMoviesUseCaseKey.self] = newValue }
    }

}
