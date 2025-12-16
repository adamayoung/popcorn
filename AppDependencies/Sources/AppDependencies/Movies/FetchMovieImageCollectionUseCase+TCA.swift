//
//  FetchMovieImageCollectionUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
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

extension DependencyValues {

    public var fetchMovieImageCollection: any FetchMovieImageCollectionUseCase {
        get { self[FetchMovieImageCollectionUseCaseKey.self] }
        set { self[FetchMovieImageCollectionUseCaseKey.self] = newValue }
    }

}
