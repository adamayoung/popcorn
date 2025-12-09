//
//  FetchMovieGenresUseCase.swift
//  PopcornGenres
//
//  Created by Adam Young on 06/06/2025.
//

import Foundation
import GenresDomain

public protocol FetchMovieGenresUseCase: Sendable {

    func execute() async throws(FetchMovieGenresError) -> [Genre]

}
