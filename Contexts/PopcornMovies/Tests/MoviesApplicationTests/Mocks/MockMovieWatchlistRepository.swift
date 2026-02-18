//
//  MockMovieWatchlistRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

final class MockMovieWatchlistRepository: MovieWatchlistRepository, @unchecked Sendable {

    var moviesCallCount = 0
    var moviesStub: Result<Set<WatchlistMovie>, MovieWatchlistRepositoryError>?

    var moviesStreamCallCount = 0
    var moviesStreamStub: AsyncThrowingStream<Set<WatchlistMovie>, Error>?

    var isOnWatchlistCallCount = 0
    var isOnWatchlistCalledWith: [Int] = []
    var isOnWatchlistStub: Result<Bool, MovieWatchlistRepositoryError>?

    var addMovieCallCount = 0
    var addMovieCalledWith: [Int] = []
    var addMovieError: MovieWatchlistRepositoryError?

    var removeMovieCallCount = 0
    var removeMovieCalledWith: [Int] = []
    var removeMovieError: MovieWatchlistRepositoryError?

    func movies() async throws(MovieWatchlistRepositoryError) -> Set<WatchlistMovie> {
        moviesCallCount += 1

        guard let stub = moviesStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func moviesStream() async -> AsyncThrowingStream<Set<WatchlistMovie>, Error> {
        moviesStreamCallCount += 1
        return moviesStreamStub ?? AsyncThrowingStream { $0.finish() }
    }

    func isOnWatchlist(movieID id: Int) async throws(MovieWatchlistRepositoryError) -> Bool {
        isOnWatchlistCallCount += 1
        isOnWatchlistCalledWith.append(id)

        guard let stub = isOnWatchlistStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }

    func addMovie(withID id: Int) async throws(MovieWatchlistRepositoryError) {
        addMovieCallCount += 1
        addMovieCalledWith.append(id)

        if let error = addMovieError {
            throw error
        }
    }

    func removeMovie(withID id: Int) async throws(MovieWatchlistRepositoryError) {
        removeMovieCallCount += 1
        removeMovieCalledWith.append(id)

        if let error = removeMovieError {
            throw error
        }
    }

}
