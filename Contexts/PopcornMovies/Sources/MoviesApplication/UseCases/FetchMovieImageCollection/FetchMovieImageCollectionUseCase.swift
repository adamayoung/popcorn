//
//  FetchMovieImageCollectionUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public protocol FetchMovieImageCollectionUseCase: Sendable {

    func execute(movieID: Movie.ID) async throws(FetchMovieImageCollectionError)
        -> ImageCollectionDetails

}
