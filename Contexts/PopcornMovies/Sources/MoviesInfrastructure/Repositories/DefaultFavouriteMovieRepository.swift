//
//  DefaultFavouriteMovieRepository.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation
import MoviesDomain

final class DefaultFavouriteMovieRepository: FavouriteMovieRepository {

    private let localDataSource: any FavouriteMovieLocalDataSource

    init(localDataSource: some FavouriteMovieLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func favourites() async throws(FavouriteMovieRepositoryError) -> Set<FavouriteMovie> {
        let favouriteMovies: Set<FavouriteMovie>
        do {
            favouriteMovies = try await localDataSource.favourites()
        } catch let error {
            throw FavouriteMovieRepositoryError(error)
        }

        return favouriteMovies
    }

    func isFavourite(movieID id: Int) async throws(FavouriteMovieRepositoryError) -> Bool {
        do { return try await localDataSource.isFavourite(movieID: id) } catch let error {
            throw FavouriteMovieRepositoryError(error)
        }
    }

    func saveFavourite(withID id: Int) async throws(FavouriteMovieRepositoryError) {
        do { try await localDataSource.saveFavourite(withID: id) } catch let error {
            throw FavouriteMovieRepositoryError(error)
        }
    }

    func deleteFavourite(withID id: Int) async throws(FavouriteMovieRepositoryError) {
        do { try await localDataSource.deleteFavourite(withID: id) } catch let error {
            throw FavouriteMovieRepositoryError(error)
        }
    }

}

extension FavouriteMovieRepositoryError {

    init(_ error: FavouriteMovieLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
