//
//  FetchSimilarMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchSimilarMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchSimilarMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchSimilarMoviesUseCase()
    }

}

extension DependencyValues {

    public var fetchSimilarMovies: any FetchSimilarMoviesUseCase {
        get { self[FetchSimilarMoviesUseCaseKey.self] }
        set { self[FetchSimilarMoviesUseCaseKey.self] = newValue }
    }

}
