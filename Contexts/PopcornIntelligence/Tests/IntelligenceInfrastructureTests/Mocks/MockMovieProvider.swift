//
//  MockMovieProvider.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

final class MockMovieProvider: MovieProviding, @unchecked Sendable {

    var movieCallCount = 0
    var movieCalledWith: [Int] = []
    var movieStub: Result<Movie, MovieProviderError>?

    func movie(withID id: Int) async throws(MovieProviderError) -> Movie {
        movieCallCount += 1
        movieCalledWith.append(id)

        guard let stub = movieStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let movie):
            return movie
        case .failure(let error):
            throw error
        }
    }

}
