//
//  MovieMapper.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication

struct MovieMapper {

    private let genreMapper = GenreMapper()

    func map(_ movieDetails: MovieDetails) -> Movie {
        Movie(
            id: movieDetails.id,
            title: movieDetails.title,
            tagline: movieDetails.tagline,
            overview: movieDetails.overview,
            runtime: movieDetails.runtime,
            genres: movieDetails.genres?.map(genreMapper.map),
            releaseDate: movieDetails.releaseDate,
            posterURL: movieDetails.posterURLSet?.detail,
            backdropURL: movieDetails.backdropURLSet?.full,
            logoURL: movieDetails.logoURLSet?.detail,
            budget: movieDetails.budget,
            revenue: movieDetails.revenue,
            homepageURL: movieDetails.homepageURL,
            certification: movieDetails.certification,
            isOnWatchlist: movieDetails.isOnWatchlist
        )
    }

}
