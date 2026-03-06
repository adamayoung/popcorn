//
//  FetchAllGenresUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import GenresApplication

enum FetchAllGenresUseCaseKey: DependencyKey {

    static var liveValue: any FetchAllGenresUseCase {
        DependencyValues._current
            .genresFactory
            .makeFetchAllGenresUseCase()
    }

}

public extension DependencyValues {

    var fetchAllGenres: any FetchAllGenresUseCase {
        get { self[FetchAllGenresUseCaseKey.self] }
        set { self[FetchAllGenresUseCaseKey.self] = newValue }
    }

}
