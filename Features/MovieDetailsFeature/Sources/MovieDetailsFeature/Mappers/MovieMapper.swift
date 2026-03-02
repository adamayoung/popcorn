//
//  MovieMapper.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

struct MovieMapper {

    private let genreMapper = GenreMapper()

    func map(_ movieDetails: MovieDetails) -> Movie {
        let genres: [Genre]? = {
            guard let genres = movieDetails.genres else {
                return nil
            }

            return genres.map(genreMapper.map)
        }()

        return Movie(
            id: movieDetails.id,
            title: movieDetails.title,
            tagline: movieDetails.tagline,
            overview: movieDetails.overview,
            runtime: movieDetails.runtime,
            genres: genres,
            releaseDate: movieDetails.releaseDate,
            posterURL: movieDetails.posterURLSet?.detail,
            smallPosterURL: movieDetails.posterURLSet?.thumbnail,
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
