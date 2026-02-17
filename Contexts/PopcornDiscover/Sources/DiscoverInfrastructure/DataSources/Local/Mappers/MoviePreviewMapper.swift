//
//  MoviePreviewMapper.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

struct MoviePreviewMapper {

    func map(_ entity: DiscoverMoviePreviewEntity) -> MoviePreview {
        MoviePreview(
            id: entity.movieID,
            title: entity.title,
            overview: entity.overview,
            releaseDate: entity.releaseDate,
            genreIDs: entity.genreIDs,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath
        )
    }

    func compactMap(_ entity: DiscoverMoviePreviewEntity?) -> MoviePreview? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ movie: MoviePreview) -> DiscoverMoviePreviewEntity {
        DiscoverMoviePreviewEntity(
            movieID: movie.id,
            title: movie.title,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            genreIDs: movie.genreIDs,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath
        )
    }

    func map(_ movie: MoviePreview, to entity: DiscoverMoviePreviewEntity) {
        entity.title = movie.title
        entity.overview = movie.overview
        entity.releaseDate = movie.releaseDate
        entity.genreIDs = movie.genreIDs
        entity.posterPath = movie.posterPath
        entity.backdropPath = movie.backdropPath
        entity.cachedAt = .now
    }

}
