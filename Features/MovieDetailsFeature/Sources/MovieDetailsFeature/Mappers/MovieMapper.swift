//
//  MovieMapper.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 20/11/2025.
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
            isFavourite: movieDetails.isFavourite
        )
    }

}
