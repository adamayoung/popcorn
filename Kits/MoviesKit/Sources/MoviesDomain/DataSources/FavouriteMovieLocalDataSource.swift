//
//  FavouriteMovieLocalDataSource.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

public protocol FavouriteMovieLocalDataSource: Sendable, Actor {

    func favourites() async throws(FavouriteMovieLocalDataSourceError) -> Set<FavouriteMovie>

    func isFavourite(
        movieID id: Int
    ) async throws(FavouriteMovieLocalDataSourceError) -> Bool

    func saveFavourite(
        withID id: Int
    ) async throws(FavouriteMovieLocalDataSourceError)

    func deleteFavourite(
        withID id: Int
    ) async throws(FavouriteMovieLocalDataSourceError)

}

public enum FavouriteMovieLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
