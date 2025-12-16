//
//  FetchMovieDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 18/11/2025.
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

extension DependencyValues {

    public var fetchMovieDetails: any FetchMovieDetailsUseCase {
        get { self[FetchMovieDetailsUseCaseKey.self] }
        set { self[FetchMovieDetailsUseCaseKey.self] = newValue }
    }

}
