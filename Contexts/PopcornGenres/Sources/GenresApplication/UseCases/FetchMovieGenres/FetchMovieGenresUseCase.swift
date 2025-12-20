//
//  FetchMovieGenresUseCase.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

public protocol FetchMovieGenresUseCase: Sendable {

    func execute() async throws(FetchMovieGenresError) -> [Genre]

}
