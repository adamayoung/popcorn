//
//  FetchMovieImageCollectionUseCase+TCA.swift
//  MoviesKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieImageCollectionUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieImageCollectionUseCase {
        DependencyValues._current
            .moviesFactory
            .makeFetchMovieImageCollectionUseCase()
    }

}

extension DependencyValues {

    public var fetchMovieImageCollection: any FetchMovieImageCollectionUseCase {
        get { self[FetchMovieImageCollectionUseCaseKey.self] }
        set { self[FetchMovieImageCollectionUseCaseKey.self] = newValue }
    }

}
