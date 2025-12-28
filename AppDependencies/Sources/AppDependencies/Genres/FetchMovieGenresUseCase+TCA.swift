//
//  FetchMovieGenresUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
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

    ///
    /// A use case for fetching the list of movie genres.
    ///
    /// Retrieves all available movie genres used for categorising and filtering movies.
    ///
    var fetchMovieGenres: any FetchMovieGenresUseCase {
        get { self[FetchMovieGenresUseCaseKey.self] }
        set { self[FetchMovieGenresUseCaseKey.self] = newValue }
    }

}
