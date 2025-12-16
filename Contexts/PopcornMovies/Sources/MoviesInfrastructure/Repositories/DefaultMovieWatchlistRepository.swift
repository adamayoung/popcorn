//
//  DefaultMovieWatchlistRepository.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation
import MoviesDomain

final class DefaultMovieWatchlistRepository: MovieWatchlistRepository {

    private let localDataSource: any MovieWatchlistLocalDataSource

    init(localDataSource: some MovieWatchlistLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func movies() async throws(MovieWatchlistRepositoryError) -> Set<WatchlistMovie> {
        let watchlistMovies: Set<WatchlistMovie>
        do {
            watchlistMovies = try await localDataSource.movies()
        } catch let error {
            throw MovieWatchlistRepositoryError(error)
        }

        return watchlistMovies
    }

    func isOnWatchlist(movieID id: Int) async throws(MovieWatchlistRepositoryError) -> Bool {
        do { return try await localDataSource.isOnWatchlist(movieID: id) } catch let error {
            throw MovieWatchlistRepositoryError(error)
        }
    }

    func addMovie(withID id: Int) async throws(MovieWatchlistRepositoryError) {
        do { try await localDataSource.addMovie(withID: id) } catch let error {
            throw MovieWatchlistRepositoryError(error)
        }
    }

    func removeMovie(withID id: Int) async throws(MovieWatchlistRepositoryError) {
        do { try await localDataSource.removeMovie(withID: id) } catch let error {
            throw MovieWatchlistRepositoryError(error)
        }
    }

}

extension MovieWatchlistRepositoryError {

    init(_ error: MovieWatchlistLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
