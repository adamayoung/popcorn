//
//  StreamPopularMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamPopularMoviesUseCaseKey: DependencyKey {

    static var liveValue: any StreamPopularMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamPopularMoviesUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for streaming a list of popular movies.
    ///
    /// Provides a continuous stream of popular movies that updates when
    /// the underlying data changes.
    ///
    var streamPopularMovies: any StreamPopularMoviesUseCase {
        get { self[StreamPopularMoviesUseCaseKey.self] }
        set { self[StreamPopularMoviesUseCaseKey.self] = newValue }
    }

}
