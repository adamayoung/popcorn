//
//  FetchTVSeriesGenresUseCase+TCA.swift
//  PopcornGenresAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation
import GenresApplication

enum FetchTVSeriesGenresUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesGenresUseCase {
        DependencyValues._current
            .genresFactory
            .makeFetchTVSeriesGenresUseCase()
    }

}

extension DependencyValues {

    public var fetchTVSeriesGenres: any FetchTVSeriesGenresUseCase {
        get { self[FetchTVSeriesGenresUseCaseKey.self] }
        set { self[FetchTVSeriesGenresUseCaseKey.self] = newValue }
    }

}
