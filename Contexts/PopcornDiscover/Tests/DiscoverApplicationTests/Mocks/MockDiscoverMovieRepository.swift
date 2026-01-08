//
//  MockDiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

final class MockDiscoverMovieRepository: DiscoverMovieRepository, @unchecked Sendable {

    var moviesCallCount = 0
    var moviesCalledWith: [(filter: MovieFilter?, page: Int)] = []
    var moviesStub: Result<[MoviePreview], DiscoverMovieRepositoryError>?

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieRepositoryError) -> [MoviePreview] {
        moviesCallCount += 1
        moviesCalledWith.append((filter: filter, page: page))

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

}
