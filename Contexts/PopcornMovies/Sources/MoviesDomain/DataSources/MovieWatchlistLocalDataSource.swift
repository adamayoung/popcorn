//
//  MovieWatchlistLocalDataSource.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

public protocol MovieWatchlistLocalDataSource: Sendable, Actor {

    func movies() async throws(MovieWatchlistLocalDataSourceError) -> Set<WatchlistMovie>

    func isOnWatchlist(
        movieID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError) -> Bool

    func addMovie(
        withID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError)

    func removeMovie(
        withID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError)

}

public enum MovieWatchlistLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
