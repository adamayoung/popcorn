//
//  FetchMovieCreditsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public protocol FetchMovieCreditsUseCase: Sendable {

    func execute(movieID: Movie.ID) async throws(FetchMovieCreditsError) -> CreditsDetails

}
