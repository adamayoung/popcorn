//
//  FetchMovieDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieDetailsUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieDetailsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieDetailsUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for fetching detailed information about a specific movie.
    ///
    /// Retrieves comprehensive details for a movie including cast, crew,
    /// runtime, and other metadata.
    ///
    var fetchMovieDetails: any FetchMovieDetailsUseCase {
        get { self[FetchMovieDetailsUseCaseKey.self] }
        set { self[FetchMovieDetailsUseCaseKey.self] = newValue }
    }

}
