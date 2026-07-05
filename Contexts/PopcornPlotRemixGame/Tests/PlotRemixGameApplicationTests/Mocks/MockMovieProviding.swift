//
//  MockMovieProviding.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain
import Synchronization

/// `randomSimilarMovies` is invoked concurrently -- once per movie -- from
/// `DefaultGeneratePlotRemixGameUseCase`'s task group, so call-tracking state is kept behind
/// a `Mutex` to avoid data races across the concurrent child tasks.
final class MockMovieProviding: MovieProviding, @unchecked Sendable {

    struct RandomMoviesCall: Equatable {
        let filter: MovieFilter
        let limit: Int
    }

    struct RandomSimilarMoviesCall: Equatable {
        let movieID: Int
        let limit: Int
    }

    private struct CallState {
        var randomMoviesCallCount = 0
        var randomMoviesCalledWith: [RandomMoviesCall] = []
        var randomSimilarMoviesCallCount = 0
        var randomSimilarMoviesCalledWith: [RandomSimilarMoviesCall] = []
    }

    private let callState = Mutex(CallState())

    var randomMoviesStub: Result<[Movie], MovieProviderError>?
    var randomSimilarMoviesStub: Result<[Movie], MovieProviderError>?
    var randomSimilarMoviesStubsByMovieID: [Int: Result<[Movie], MovieProviderError>] = [:]

    var randomMoviesCallCount: Int {
        callState.withLock { $0.randomMoviesCallCount }
    }

    var randomMoviesCalledWith: [RandomMoviesCall] {
        callState.withLock { $0.randomMoviesCalledWith }
    }

    var randomSimilarMoviesCallCount: Int {
        callState.withLock { $0.randomSimilarMoviesCallCount }
    }

    var randomSimilarMoviesCalledWith: [RandomSimilarMoviesCall] {
        callState.withLock { $0.randomSimilarMoviesCalledWith }
    }

    func randomMovies(filter: MovieFilter, limit: Int) async throws(MovieProviderError) -> [Movie] {
        callState.withLock {
            $0.randomMoviesCallCount += 1
            $0.randomMoviesCalledWith.append(RandomMoviesCall(filter: filter, limit: limit))
        }

        guard let stub = randomMoviesStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func randomSimilarMovies(
        to movieID: Int,
        limit: Int
    ) async throws(MovieProviderError) -> [Movie] {
        callState.withLock {
            $0.randomSimilarMoviesCallCount += 1
            $0.randomSimilarMoviesCalledWith.append(RandomSimilarMoviesCall(movieID: movieID, limit: limit))
        }

        if let stubForMovie = randomSimilarMoviesStubsByMovieID[movieID] {
            switch stubForMovie {
            case .success(let movies):
                return movies
            case .failure(let error):
                throw error
            }
        }

        guard let stub = randomSimilarMoviesStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

}
