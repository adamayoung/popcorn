//
//  FetchMovieCreditsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public protocol FetchMovieCreditsUseCase: Sendable {

    func execute(movieID: Movie.ID) async throws(FetchMovieCreditsError) -> CreditsDetails

}
