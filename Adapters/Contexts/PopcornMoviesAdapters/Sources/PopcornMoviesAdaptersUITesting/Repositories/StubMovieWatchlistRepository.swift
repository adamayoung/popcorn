//
//  StubMovieWatchlistRepository.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public final class StubMovieWatchlistRepository: MovieWatchlistRepository, @unchecked Sendable {

    private var watchlist: Set<WatchlistMovie> = []

    public init() {}

    public func movies() async throws(MovieWatchlistRepositoryError) -> Set<WatchlistMovie> {
        watchlist
    }

    public func isOnWatchlist(movieID id: Int) async throws(MovieWatchlistRepositoryError) -> Bool {
        watchlist.contains { $0.id == id }
    }

    public func addMovie(withID id: Int) async throws(MovieWatchlistRepositoryError) {
        watchlist.insert(WatchlistMovie(id: id, createdAt: Date()))
    }

    public func removeMovie(withID id: Int) async throws(MovieWatchlistRepositoryError) {
        watchlist = watchlist.filter { $0.id != id }
    }

}
