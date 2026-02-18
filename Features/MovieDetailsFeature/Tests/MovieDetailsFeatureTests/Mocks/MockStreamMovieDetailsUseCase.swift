//
//  MockStreamMovieDetailsUseCase.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

struct MockStreamMovieDetailsUseCase: StreamMovieDetailsUseCase {

    let movieDetails: [MoviesApplication.MovieDetails?]

    init(movieDetails: [MoviesApplication.MovieDetails?] = []) {
        self.movieDetails = movieDetails
    }

    func stream(id: Int) async -> AsyncThrowingStream<MoviesApplication.MovieDetails?, Error> {
        AsyncThrowingStream { continuation in
            for movie in movieDetails {
                continuation.yield(movie)
            }
            continuation.finish()
        }
    }

}
