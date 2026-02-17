//
//  FetchPopularMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchPopularMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchPopularMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchPopularMoviesUseCase()
    }

}

public extension DependencyValues {

    var fetchPopularMovies: any FetchPopularMoviesUseCase {
        get { self[FetchPopularMoviesUseCaseKey.self] }
        set { self[FetchPopularMoviesUseCaseKey.self] = newValue }
    }

}
