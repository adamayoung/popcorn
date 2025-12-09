//
//  FetchMovieGenresUseCase+TCA.swift
//  PopcornGenresAdapters
//
//  Created by Adam Young on 09/12/2025.
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

extension DependencyValues {

    public var fetchMovieGenres: any FetchMovieGenresUseCase {
        get { self[FetchMovieGenresUseCaseKey.self] }
        set { self[FetchMovieGenresUseCaseKey.self] = newValue }
    }

}
