//
//  StreamMovieDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamMovieDetailsUseCaseKey: DependencyKey {

    static var liveValue: any StreamMovieDetailsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamMovieDetailsUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for streaming detailed information about a specific movie.
    ///
    /// Provides a continuous stream of movie details that updates when
    /// the underlying data changes.
    ///
    var streamMovieDetails: any StreamMovieDetailsUseCase {
        get { self[StreamMovieDetailsUseCaseKey.self] }
        set { self[StreamMovieDetailsUseCaseKey.self] = newValue }
    }

}
