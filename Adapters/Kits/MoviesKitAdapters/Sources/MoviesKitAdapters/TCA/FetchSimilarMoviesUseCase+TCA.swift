//
//  FetchSimilarMoviesUseCase+TCA.swift
//  MoviesKitAdapters
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchSimilarMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchSimilarMoviesUseCase {
        DependencyValues._current
            .moviesFactory
            .makeFetchSimilarMoviesUseCase()
    }

}

extension DependencyValues {

    public var fetchSimilarMovies: any FetchSimilarMoviesUseCase {
        get { self[FetchSimilarMoviesUseCaseKey.self] }
        set { self[FetchSimilarMoviesUseCaseKey.self] = newValue }
    }

}
