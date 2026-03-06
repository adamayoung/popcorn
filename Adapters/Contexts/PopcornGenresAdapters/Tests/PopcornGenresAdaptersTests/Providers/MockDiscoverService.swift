//
//  MockDiscoverService.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockDiscoverService: DiscoverService, @unchecked Sendable {

    var moviesCallCount = 0
    var moviesStub: Result<MoviePageableList, TMDbError>?

    var tvSeriesCallCount = 0
    var tvSeriesStub: Result<TVSeriesPageableList, TMDbError>?

    func movies(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList {
        moviesCallCount += 1

        guard let stub = moviesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }

    func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        sortedBy: TVSeriesSort?,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        tvSeriesCallCount += 1

        guard let stub = tvSeriesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }

}
