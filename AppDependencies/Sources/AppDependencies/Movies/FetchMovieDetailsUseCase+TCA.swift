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

    var fetchMovieDetails: any FetchMovieDetailsUseCase {
        get { self[FetchMovieDetailsUseCaseKey.self] }
        set { self[FetchMovieDetailsUseCaseKey.self] = newValue }
    }

}
