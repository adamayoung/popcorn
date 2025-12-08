//
//  FetchPopularMoviesUseCase+TCA.swift
//  MoviesKitAdapters
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchPopularMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchPopularMoviesUseCase {
        DependencyValues._current
            .moviesFactory
            .makeFetchPopularMoviesUseCase()
    }

}

extension DependencyValues {

    public var fetchPopularMovies: any FetchPopularMoviesUseCase {
        get { self[FetchPopularMoviesUseCaseKey.self] }
        set { self[FetchPopularMoviesUseCaseKey.self] = newValue }
    }

}
