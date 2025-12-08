//
//  StreamPopularMoviesUseCase+TCA.swift
//  PopcornMoviesAdapters
//
//  Created by Adam Young on 02/12/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamPopularMoviesUseCaseKey: DependencyKey {

    static var liveValue: any StreamPopularMoviesUseCase {
        DependencyValues._current
            .moviesFactory
            .makeStreamPopularMoviesUseCase()
    }

}

extension DependencyValues {

    public var streamPopularMovies: any StreamPopularMoviesUseCase {
        get { self[StreamPopularMoviesUseCaseKey.self] }
        set { self[StreamPopularMoviesUseCaseKey.self] = newValue }
    }

}
