//
//  WatchlistMovieMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

struct WatchlistMovieMapper {

    func map(_ entity: MoviesWatchlistMovieEntity) -> WatchlistMovie? {
        guard
            let id = entity.movieID,
            let createdAt = entity.createdAt
        else {
            return nil
        }

        return WatchlistMovie(
            id: id,
            createdAt: createdAt
        )
    }

    func map(_ watchlistMovie: WatchlistMovie) -> MoviesWatchlistMovieEntity {
        MoviesWatchlistMovieEntity(
            movieID: watchlistMovie.id,
            createdAt: watchlistMovie.createdAt
        )
    }

}
