//
//  FetchMovieWatchProvidersUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieWatchProvidersUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieWatchProvidersUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieWatchProvidersUseCase()
    }

}

public extension DependencyValues {

    var fetchMovieWatchProviders: any FetchMovieWatchProvidersUseCase {
        get { self[FetchMovieWatchProvidersUseCaseKey.self] }
        set { self[FetchMovieWatchProvidersUseCaseKey.self] = newValue }
    }

}
