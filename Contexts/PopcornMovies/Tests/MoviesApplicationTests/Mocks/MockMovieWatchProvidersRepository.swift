//
//  MockMovieWatchProvidersRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

final class MockMovieWatchProvidersRepository: MovieWatchProvidersRepository, @unchecked Sendable {

    var watchProvidersCallCount = 0
    var watchProvidersCalledWith: [Int] = []
    var watchProvidersStub: Result<WatchProviderCollection?, MovieWatchProvidersRepositoryError>?

    func watchProviders(
        forMovie movieID: Int
    ) async throws(MovieWatchProvidersRepositoryError) -> WatchProviderCollection? {
        watchProvidersCallCount += 1
        watchProvidersCalledWith.append(movieID)

        guard let stub = watchProvidersStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let collection):
            return collection
        case .failure(let error):
            throw error
        }
    }

}
