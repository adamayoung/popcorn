//
//  MockDiscoverService.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockDiscoverService: DiscoverService, @unchecked Sendable {

    struct MoviesCall: Equatable {
        let filter: DiscoverMovieFilter?
        let sortedBy: MovieSort?
        let page: Int?
        let language: String?

        static func == (lhs: MoviesCall, rhs: MoviesCall) -> Bool {
            lhs.page == rhs.page && lhs.language == rhs.language
        }
    }

    struct TVSeriesCall: Equatable {
        let filter: DiscoverTVSeriesFilter?
        let sortedBy: TVSeriesSort?
        let page: Int?
        let language: String?

        static func == (lhs: TVSeriesCall, rhs: TVSeriesCall) -> Bool {
            lhs.page == rhs.page && lhs.language == rhs.language
        }
    }

    var moviesCallCount = 0
    var moviesCalledWith: [MoviesCall] = []
    var moviesStub: Result<MoviePageableList, TMDbError>?

    var tvSeriesCallCount = 0
    var tvSeriesCalledWith: [TVSeriesCall] = []
    var tvSeriesStub: Result<TVSeriesPageableList, TMDbError>?

    func movies(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList {
        moviesCallCount += 1
        moviesCalledWith.append(MoviesCall(filter: filter, sortedBy: sortedBy, page: page, language: language))

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
        tvSeriesCalledWith.append(TVSeriesCall(filter: filter, sortedBy: sortedBy, page: page, language: language))

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
