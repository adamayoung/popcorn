//
//  MockMovieCreditsRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

final class MockMovieCreditsRepository: MovieCreditsRepository, @unchecked Sendable {

    var creditsCallCount = 0
    var creditsCalledWith: [Int] = []
    var creditsStub: Result<Credits, MovieCreditsRepositoryError>?

    func credits(forMovie movieID: Int) async throws(MovieCreditsRepositoryError) -> Credits {
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

}
