//
//  FetchMovieGenresUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import GenresApplication

enum FetchMovieGenresUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieGenresUseCase {
        DependencyValues._current
            .genresFactory
            .makeFetchMovieGenresUseCase()
    }

}

public extension DependencyValues {

    var fetchMovieGenres: any FetchMovieGenresUseCase {
        get { self[FetchMovieGenresUseCaseKey.self] }
        set { self[FetchMovieGenresUseCaseKey.self] = newValue }
    }

}
