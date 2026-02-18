//
//  StreamWatchlistMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamWatchlistMoviesUseCaseKey: DependencyKey {

    static var liveValue: any StreamWatchlistMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamWatchlistMoviesUseCase()
    }

}

public extension DependencyValues {

    var streamWatchlistMovies: any StreamWatchlistMoviesUseCase {
        get { self[StreamWatchlistMoviesUseCaseKey.self] }
        set { self[StreamWatchlistMoviesUseCaseKey.self] = newValue }
    }

}
