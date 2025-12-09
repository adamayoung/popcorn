//
//  FetchMovieDetailsUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/06/2025.
//

import Foundation
import MoviesDomain

public protocol FetchMovieDetailsUseCase: Sendable {

    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails

}
