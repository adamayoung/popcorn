//
//  StreamPopularMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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

    var streamPopularMovies: any StreamPopularMoviesUseCase {
        get { self[StreamPopularMoviesUseCaseKey.self] }
        set { self[StreamPopularMoviesUseCaseKey.self] = newValue }
    }

}
