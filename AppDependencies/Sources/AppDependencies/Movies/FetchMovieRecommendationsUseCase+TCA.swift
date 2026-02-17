//
//  FetchMovieRecommendationsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieRecommendationsUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieRecommendationsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieRecommendationsUseCase()
    }

}

public extension DependencyValues {

    var fetchMovieRecommendations: any FetchMovieRecommendationsUseCase {
        get { self[FetchMovieRecommendationsUseCaseKey.self] }
        set { self[FetchMovieRecommendationsUseCaseKey.self] = newValue }
    }

}
