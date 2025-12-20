//
//  FetchMovieUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public protocol FetchMovieDetailsUseCase: Sendable {

    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails

}
