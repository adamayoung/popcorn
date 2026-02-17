//
//  PopcornGenresFactory.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresApplication

public protocol PopcornGenresFactory: Sendable {

    func makeFetchMovieGenresUseCase() -> FetchMovieGenresUseCase

    func makeFetchTVSeriesGenresUseCase() -> FetchTVSeriesGenresUseCase

}
