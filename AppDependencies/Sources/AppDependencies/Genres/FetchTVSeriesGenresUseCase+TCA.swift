//
//  FetchTVSeriesGenresUseCase+TCA.swift
//  AppDependencies
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

    ///
    /// A use case for fetching the list of TV series genres.
    ///
    /// Retrieves all available TV series genres used for categorising and filtering TV series.
    ///
    var fetchTVSeriesGenres: any FetchTVSeriesGenresUseCase {
        get { self[FetchTVSeriesGenresUseCaseKey.self] }
        set { self[FetchTVSeriesGenresUseCaseKey.self] = newValue }
    }

}
