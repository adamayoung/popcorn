//
//  MovieMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct MovieMapper {

    private let genreMapper = GenreMapper()

    func map(_ dto: TMDb.Movie) -> MoviesDomain.Movie {
        MoviesDomain.Movie(
            id: dto.id,
            title: dto.title,
            tagline: dto.tagline,
            overview: dto.overview ?? "",
            runtime: dto.runtime,
            genres: dto.genres?.map(genreMapper.map),
            releaseDate: dto.releaseDate,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            budget: dto.budget,
            revenue: dto.revenue,
            homepageURL: dto.homepageURL
        )
    }

}
