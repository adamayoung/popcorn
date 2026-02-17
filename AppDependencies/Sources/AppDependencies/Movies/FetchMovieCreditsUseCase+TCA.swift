//
//  FetchMovieCreditsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieCreditsUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieCreditsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieCreditsUseCase()
    }

}

public extension DependencyValues {

    var fetchMovieCredits: any FetchMovieCreditsUseCase {
        get { self[FetchMovieCreditsUseCaseKey.self] }
        set { self[FetchMovieCreditsUseCaseKey.self] = newValue }
    }

}
