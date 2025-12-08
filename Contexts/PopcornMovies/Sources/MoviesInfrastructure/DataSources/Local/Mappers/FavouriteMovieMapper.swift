//
//  FavouriteMovieMapper.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation
import MoviesDomain

struct FavouriteMovieMapper {

    func map(_ entity: FavouriteMovieEntity) -> FavouriteMovie? {
        guard
            let id = entity.movieID,
            let createdAt = entity.createdAt
        else {
            return nil
        }

        return FavouriteMovie(
            id: id,
            createdAt: createdAt
        )
    }

    func map(_ favouriteMovie: FavouriteMovie) -> FavouriteMovieEntity {
        FavouriteMovieEntity(
            movieID: favouriteMovie.id,
            createdAt: favouriteMovie.createdAt
        )
    }

}
