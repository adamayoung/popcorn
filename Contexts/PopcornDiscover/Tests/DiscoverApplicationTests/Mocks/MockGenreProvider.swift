//
//  MockGenreProvider.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

final class MockGenreProvider: GenreProviding, @unchecked Sendable {

    var movieGenresCallCount = 0
    var movieGenresStub: Result<[Genre], GenreProviderError>?

    func movieGenres() async throws(GenreProviderError) -> [Genre] {
        movieGenresCallCount += 1

        guard let stub = movieGenresStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

    var tvSeriesGenresCallCount = 0
    var tvSeriesGenresStub: Result<[Genre], GenreProviderError>?

    func tvSeriesGenres() async throws(GenreProviderError) -> [Genre] {
        tvSeriesGenresCallCount += 1

        guard let stub = tvSeriesGenresStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

}
