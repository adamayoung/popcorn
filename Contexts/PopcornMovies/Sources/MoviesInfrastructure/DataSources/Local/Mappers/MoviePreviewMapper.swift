//
//  MoviePreviewMapper.swift
//  PopcornMovies
//
//  Created by Adam Young on 05/11/2025.
//

import Foundation
import MoviesDomain

struct MoviePreviewMapper {

    func map(_ entity: MoviePreviewEntity) -> MoviePreview {
        MoviePreview(
            id: entity.movieID,
            title: entity.title,
            overview: entity.overview,
            releaseDate: entity.releaseDate,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath
        )
    }

    func compactMap(_ entity: MoviePreviewEntity?) -> MoviePreview? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ movie: MoviePreview) -> MoviePreviewEntity {
        MoviePreviewEntity(
            movieID: movie.id,
            title: movie.title,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath
        )
    }

    func map(_ movie: MoviePreview, to entity: MoviePreviewEntity) {
        entity.title = movie.title
        entity.overview = movie.overview
        entity.releaseDate = movie.releaseDate
        entity.posterPath = movie.posterPath
        entity.backdropPath = movie.backdropPath
        entity.cachedAt = .now
    }

}
