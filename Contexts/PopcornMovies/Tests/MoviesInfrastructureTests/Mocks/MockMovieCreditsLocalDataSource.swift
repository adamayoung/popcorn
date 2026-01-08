//
//  MockMovieCreditsLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure

actor MockMovieCreditsLocalDataSource: MovieCreditsLocalDataSource {

    nonisolated(unsafe) var creditsCallCount = 0
    nonisolated(unsafe) var creditsCalledWith: [Int] = []
    nonisolated(unsafe) var creditsStub: Result<Credits?, MovieCreditsLocalDataSourceError>?

    func credits(forMovie movieID: Int) async throws(MovieCreditsLocalDataSourceError) -> Credits? {
        creditsCallCount += 1
        creditsCalledWith.append(movieID)

        guard let stub = creditsStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    nonisolated(unsafe) var setCreditsCallCount = 0
    nonisolated(unsafe) var setCreditsCalledWith: [(credits: Credits, movieID: Int)] = []
    nonisolated(unsafe) var setCreditsStub: Result<Void, MovieCreditsLocalDataSourceError>?

    func setCredits(_ credits: Credits, forMovie movieID: Int) async throws(MovieCreditsLocalDataSourceError) {
        setCreditsCallCount += 1
        setCreditsCalledWith.append((credits: credits, movieID: movieID))

        if case .failure(let error) = setCreditsStub {
            throw error
        }
    }

}
