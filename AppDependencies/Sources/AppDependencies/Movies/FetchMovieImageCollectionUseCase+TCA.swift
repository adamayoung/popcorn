//
//  FetchMovieImageCollectionUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieImageCollectionUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieImageCollectionUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieImageCollectionUseCase()
    }

}

public extension DependencyValues {

    var fetchMovieImageCollection: any FetchMovieImageCollectionUseCase {
        get { self[FetchMovieImageCollectionUseCaseKey.self] }
        set { self[FetchMovieImageCollectionUseCaseKey.self] = newValue }
    }

}
