//
//  FetchPopularMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
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

    ///
    /// A use case for fetching a list of popular movies.
    ///
    /// Retrieves movies ranked by popularity based on user engagement metrics.
    ///
    var fetchPopularMovies: any FetchPopularMoviesUseCase {
        get { self[FetchPopularMoviesUseCaseKey.self] }
        set { self[FetchPopularMoviesUseCaseKey.self] = newValue }
    }

}
