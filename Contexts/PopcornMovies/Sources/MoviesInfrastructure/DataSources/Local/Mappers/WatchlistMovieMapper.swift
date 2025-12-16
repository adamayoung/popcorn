//
//  WatchlistMovieMapper.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
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
