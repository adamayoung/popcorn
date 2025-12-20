//
//  FetchSimilarMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchSimilarMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchSimilarMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchSimilarMoviesUseCase()
    }

}

public extension DependencyValues {

    var fetchSimilarMovies: any FetchSimilarMoviesUseCase {
        get { self[FetchSimilarMoviesUseCaseKey.self] }
        set { self[FetchSimilarMoviesUseCaseKey.self] = newValue }
    }

}
