//
//  MovieWatchlistLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public protocol MovieWatchlistLocalDataSource: Sendable, Actor {

    func movies() async throws(MovieWatchlistLocalDataSourceError) -> Set<WatchlistMovie>

    func moviesStream() async -> AsyncThrowingStream<Set<WatchlistMovie>, Error>

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
