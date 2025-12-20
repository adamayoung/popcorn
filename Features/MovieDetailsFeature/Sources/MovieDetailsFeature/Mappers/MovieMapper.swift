//
//  MovieMapper.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication

struct MovieMapper {

    func map(_ movieDetails: MovieDetails) -> Movie {
        Movie(
            id: movieDetails.id,
            title: movieDetails.title,
            overview: movieDetails.overview ?? "",
            posterURL: movieDetails.posterURLSet?.detail,
            backdropURL: movieDetails.backdropURLSet?.full,
            logoURL: movieDetails.logoURLSet?.detail,
            isOnWatchlist: movieDetails.isOnWatchlist
        )
    }

}
