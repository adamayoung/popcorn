//
//  MockTrendingService.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockTrendingService: TrendingService, @unchecked Sendable {

    struct MoviesCall: Equatable {
        let timeWindow: TrendingTimeWindowFilterType
        let page: Int?
        let language: String?
    }

    struct TVSeriesCall: Equatable {
        let timeWindow: TrendingTimeWindowFilterType
        let page: Int?
        let language: String?
    }

    struct PeopleCall: Equatable {
        let timeWindow: TrendingTimeWindowFilterType
        let page: Int?
        let language: String?
    }

    var moviesCallCount = 0
    var moviesCalledWith: [MoviesCall] = []
    var moviesStub: Result<MoviePageableList, TMDbError>?

    var tvSeriesCallCount = 0
    var tvSeriesCalledWith: [TVSeriesCall] = []
    var tvSeriesStub: Result<TVSeriesPageableList, TMDbError>?

    var peopleCallCount = 0
    var peopleCalledWith: [PeopleCall] = []
    var peopleStub: Result<PersonPageableList, TMDbError>?

    func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList {
        moviesCallCount += 1
        moviesCalledWith.append(MoviesCall(timeWindow: timeWindow, page: page, language: language))

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
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        tvSeriesCallCount += 1
        tvSeriesCalledWith.append(TVSeriesCall(timeWindow: timeWindow, page: page, language: language))

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

    func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> PersonPageableList {
        peopleCallCount += 1
        peopleCalledWith.append(PeopleCall(timeWindow: timeWindow, page: page, language: language))

        guard let stub = peopleStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }

    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> TrendingPageableList {
        fatalError("Not implemented")
    }

}
