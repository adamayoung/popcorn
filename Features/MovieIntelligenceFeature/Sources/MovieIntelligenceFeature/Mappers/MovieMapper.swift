//
//  MovieMapper.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication

struct MovieMapper {

    func map(_ movieDetails: MovieDetails) -> Movie {
        Movie(
            id: movieDetails.id,
            title: movieDetails.title
        )
    }

}
