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

    ///
    /// A use case for streaming movies similar to a given movie.
    ///
    /// Provides a continuous stream of similar movies that updates when
    /// the underlying data changes.
    ///
    var streamSimilarMovies: any StreamSimilarMoviesUseCase {
        get { self[StreamSimilarMoviesUseCaseKey.self] }
        set { self[StreamSimilarMoviesUseCaseKey.self] = newValue }
    }

}
