//
//  MovieWatchlistLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

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
