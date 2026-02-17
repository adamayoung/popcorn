//
//  MockFetchMovieDetailsUseCase.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

struct MockFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {

    let movieDetails: MoviesApplication.MovieDetails?

    func execute(id: Int) async throws(FetchMovieDetailsError) -> MoviesApplication.MovieDetails {
        guard let movieDetails else {
            throw .notFound
        }
        return movieDetails
    }

}
