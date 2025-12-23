//
//  MovieMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

struct MovieMapper {

    func map(_ movieDetails: MovieDetails) -> Movie {
        Movie(
            id: movieDetails.id,
            title: movieDetails.title,
            overview: movieDetails.overview ?? "",
            releaseDate: movieDetails.releaseDate,
            posterPath: movieDetails.posterURLSet?.path,
            backdropPath: movieDetails.backdropURLSet?.path
        )
    }

}
