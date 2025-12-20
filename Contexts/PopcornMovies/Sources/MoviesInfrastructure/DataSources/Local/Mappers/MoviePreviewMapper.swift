//
//  MoviePreviewMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

struct MoviePreviewMapper {

    func map(_ entity: MoviesMoviePreviewEntity) -> MoviePreview {
        MoviePreview(
            id: entity.movieID,
            title: entity.title,
            overview: entity.overview,
            releaseDate: entity.releaseDate,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath
        )
    }

    func compactMap(_ entity: MoviesMoviePreviewEntity?) -> MoviePreview? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ movie: MoviePreview) -> MoviesMoviePreviewEntity {
        MoviesMoviePreviewEntity(
            movieID: movie.id,
            title: movie.title,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath
        )
    }

    func map(_ movie: MoviePreview, to entity: MoviesMoviePreviewEntity) {
        entity.title = movie.title
        entity.overview = movie.overview
        entity.releaseDate = movie.releaseDate
        entity.posterPath = movie.posterPath
        entity.backdropPath = movie.backdropPath
        entity.cachedAt = .now
    }

}
