//
//  MovieMapper.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

struct MovieMapper {

    func map(_ entity: MoviesMovieEntity) -> Movie {
        Movie(
            id: entity.movieID,
            title: entity.title,
            tagline: entity.tagline,
            overview: entity.overview,
            runtime: entity.runtime,
            genres: entity.genres.map { mapGenres($0) },
            releaseDate: entity.releaseDate,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath,
            budget: entity.budget,
            revenue: entity.revenue,
            homepageURL: entity.homepageURL
        )
    }

    func compactMap(_ entity: MoviesMovieEntity?) -> Movie? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ movie: Movie) -> MoviesMovieEntity {
        let entity = MoviesMovieEntity(
            movieID: movie.id,
            title: movie.title,
            tagline: movie.tagline,
            overview: movie.overview,
            runtime: movie.runtime,
            releaseDate: movie.releaseDate,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            budget: movie.budget,
            revenue: movie.revenue,
            homepageURL: movie.homepageURL
        )
        entity.genres = movie.genres.map { mapGenres($0) }
        return entity
    }

    func map(_ movie: Movie, to entity: MoviesMovieEntity) {
        entity.title = movie.title
        entity.tagline = movie.tagline
        entity.overview = movie.overview
        entity.runtime = movie.runtime
        entity.releaseDate = movie.releaseDate
        entity.posterPath = movie.posterPath
        entity.backdropPath = movie.backdropPath
        entity.budget = movie.budget
        entity.revenue = movie.revenue
        entity.homepageURL = movie.homepageURL
        entity.genres = movie.genres.map { mapGenres($0) }
        entity.cachedAt = .now
    }

    // MARK: - Private

    private func mapGenres(_ genres: [MoviesGenreEntity]) -> [Genre] {
        genres.map { Genre(id: $0.genreID, name: $0.name) }
    }

    private func mapGenres(_ genres: [Genre]) -> [MoviesGenreEntity] {
        genres.map { MoviesGenreEntity(genreID: $0.id, name: $0.name) }
    }

}
