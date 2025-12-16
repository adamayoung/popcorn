//
//  StreamSimilarMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 02/12/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamSimilarMoviesUseCaseKey: DependencyKey {

    static var liveValue: any StreamSimilarMoviesUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamSimilarMoviesUseCase()
    }

}

extension DependencyValues {

    public var streamSimilarMovies: any StreamSimilarMoviesUseCase {
        get { self[StreamSimilarMoviesUseCaseKey.self] }
        set { self[StreamSimilarMoviesUseCaseKey.self] = newValue }
    }

}
