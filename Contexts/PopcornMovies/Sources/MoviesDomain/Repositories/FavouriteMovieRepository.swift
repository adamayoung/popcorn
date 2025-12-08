//
//  FavouriteMovieRepository.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

public protocol FavouriteMovieRepository: Sendable {

    func favourites() async throws(FavouriteMovieRepositoryError) -> Set<FavouriteMovie>

    func isFavourite(movieID id: Int) async throws(FavouriteMovieRepositoryError) -> Bool

    func saveFavourite(withID id: Int) async throws(FavouriteMovieRepositoryError)

    func deleteFavourite(withID id: Int) async throws(FavouriteMovieRepositoryError)

}

public enum FavouriteMovieRepositoryError: Error {

    case unknown(Error? = nil)

}
