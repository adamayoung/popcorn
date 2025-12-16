//
//  MovieWatchlistRepository.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

public protocol MovieWatchlistRepository: Sendable {

    func movies() async throws(MovieWatchlistRepositoryError) -> Set<WatchlistMovie>

    func isOnWatchlist(movieID id: Int) async throws(MovieWatchlistRepositoryError) -> Bool

    func addMovie(withID id: Int) async throws(MovieWatchlistRepositoryError)

    func removeMovie(withID id: Int) async throws(MovieWatchlistRepositoryError)

}

public enum MovieWatchlistRepositoryError: Error {

    case unknown(Error? = nil)

}
