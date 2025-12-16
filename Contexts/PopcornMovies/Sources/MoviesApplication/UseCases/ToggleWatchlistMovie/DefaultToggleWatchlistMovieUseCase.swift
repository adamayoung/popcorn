//
//  DefaultToggleWatchlistMovieUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultToggleWatchlistMovieUseCase: ToggleWatchlistMovieUseCase {

    private let movieRepository: any MovieRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository

    init(
        movieRepository: some MovieRepository,
        movieWatchlistRepository: some MovieWatchlistRepository
    ) {
        self.movieRepository = movieRepository
        self.movieWatchlistRepository = movieWatchlistRepository
    }

    func execute(id: Movie.ID) async throws(ToggleWatchlistMovieError) {
        do {
            _ = try await movieRepository.movie(withID: id)
        } catch let error {
            throw ToggleWatchlistMovieError(error)
        }

        do {
            let isFavouriteStatus = try await movieWatchlistRepository.isOnWatchlist(movieID: id)
            if isFavouriteStatus {
                try await movieWatchlistRepository.removeMovie(withID: id)
            } else {
                try await movieWatchlistRepository.addMovie(withID: id)
            }
        } catch let error {
            throw ToggleWatchlistMovieError(error)
        }
    }

}
