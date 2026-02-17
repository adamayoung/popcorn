//
//  StreamMovieRecommendationsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamMovieRecommendationsUseCaseKey: DependencyKey {

    static var liveValue: any StreamMovieRecommendationsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamMovieRecommendationsUseCase()
    }

}

public extension DependencyValues {

    var streamMovieRecommendations: any StreamMovieRecommendationsUseCase {
        get { self[StreamMovieRecommendationsUseCaseKey.self] }
        set { self[StreamMovieRecommendationsUseCaseKey.self] = newValue }
    }

}
