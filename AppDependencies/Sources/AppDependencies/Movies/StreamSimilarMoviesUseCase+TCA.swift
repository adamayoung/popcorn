//
//  StreamSimilarMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamSimilarMoviesUseCaseKey: DependencyKey {

    static var liveValue: any StreamSimilarMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamSimilarMoviesUseCase()
    }

}

public extension DependencyValues {

    var streamSimilarMovies: any StreamSimilarMoviesUseCase {
        get { self[StreamSimilarMoviesUseCaseKey.self] }
        set { self[StreamSimilarMoviesUseCaseKey.self] = newValue }
    }

}
