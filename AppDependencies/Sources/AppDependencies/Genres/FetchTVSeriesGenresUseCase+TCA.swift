//
//  FetchTVSeriesGenresUseCase+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import GenresApplication

enum FetchTVSeriesGenresUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesGenresUseCase {
        @Dependency(\.genresFactory) var genresFactory
        return genresFactory.makeFetchTVSeriesGenresUseCase()
    }

}

public extension DependencyValues {

    var fetchTVSeriesGenres: any FetchTVSeriesGenresUseCase {
        get { self[FetchTVSeriesGenresUseCaseKey.self] }
        set { self[FetchTVSeriesGenresUseCaseKey.self] = newValue }
    }

}
