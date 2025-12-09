//
//  MovieMapper.swift
//  PopcornMovies
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation
import MoviesDomain

struct MovieMapper {

    func map(_ entity: MoviesMovieEntity) -> Movie {
        Movie(
            id: entity.movieID,
            title: entity.title,
            overview: entity.overview,
            releaseDate: entity.releaseDate,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath
        )
    }

    func compactMap(_ entity: MoviesMovieEntity?) -> Movie? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ movie: Movie) -> MoviesMovieEntity {
        MoviesMovieEntity(
            movieID: movie.id,
            title: movie.title,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath
        )
    }

    func map(_ movie: Movie, to entity: MoviesMovieEntity) {
        entity.title = movie.title
        entity.overview = movie.overview
        entity.releaseDate = movie.releaseDate
        entity.cachedAt = .now
    }

}
