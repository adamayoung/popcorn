//
//  DefaultToggleFavouriteMovieUseCase.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultToggleFavouriteMovieUseCase: ToggleFavouriteMovieUseCase {

    private let movieRepository: any MovieRepository
    private let favouriteMovieRepository: any FavouriteMovieRepository

    init(
        movieRepository: some MovieRepository,
        favouriteMovieRepository: some FavouriteMovieRepository
    ) {
        self.movieRepository = movieRepository
        self.favouriteMovieRepository = favouriteMovieRepository
    }

    func execute(id: Movie.ID) async throws(ToggleFavouriteMovieError) {
        do {
            _ = try await movieRepository.movie(withID: id)
        } catch let error {
            throw ToggleFavouriteMovieError(error)
        }

        do {
            let isFavouriteStatus = try await favouriteMovieRepository.isFavourite(movieID: id)
            if isFavouriteStatus {
                try await favouriteMovieRepository.deleteFavourite(withID: id)
            } else {
                try await favouriteMovieRepository.saveFavourite(withID: id)
            }
        } catch let error {
            throw ToggleFavouriteMovieError(error)
        }
    }

}
