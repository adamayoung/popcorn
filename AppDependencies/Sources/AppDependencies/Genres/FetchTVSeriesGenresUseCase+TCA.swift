//
//  FetchTVSeriesGenresUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 09/12/2025.
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

extension DependencyValues {

    public var fetchTVSeriesGenres: any FetchTVSeriesGenresUseCase {
        get { self[FetchTVSeriesGenresUseCaseKey.self] }
        set { self[FetchTVSeriesGenresUseCaseKey.self] = newValue }
    }

}
