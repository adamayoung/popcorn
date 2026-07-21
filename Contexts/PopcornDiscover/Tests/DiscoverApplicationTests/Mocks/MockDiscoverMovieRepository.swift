//
//  MockDiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

final class MockDiscoverMovieRepository: DiscoverMovieRepository, @unchecked Sendable {

    var moviesCallCount = 0
    var moviesCalledWith: [(filter: MovieFilter?, page: Int)] = []
    var moviesStub: Result<MoviePreviewPage, DiscoverMovieRepositoryError>?

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieRepositoryError) -> MoviePreviewPage {
        moviesCallCount += 1
        moviesCalledWith.append((filter: filter, page: page))

        guard let stub = moviesStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let moviePage):
            return moviePage
        case .failure(let error):
            throw error
        }
    }

}
