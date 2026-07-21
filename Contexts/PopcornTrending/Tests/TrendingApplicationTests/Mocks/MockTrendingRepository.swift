//
//  MockTrendingRepository.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingDomain

final class MockTrendingRepository: TrendingRepository, @unchecked Sendable {

    var moviesCallCount = 0
    var moviesCalledWith: [Int] = []
    var moviesStub: Result<MoviePreviewPage, TrendingRepositoryError>?

    func movies(page: Int) async throws(TrendingRepositoryError) -> MoviePreviewPage {
        moviesCallCount += 1
        moviesCalledWith.append(page)

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

    var tvSeriesCallCount = 0
    var tvSeriesCalledWith: [Int] = []
    var tvSeriesStub: Result<[TVSeriesPreview], TrendingRepositoryError>?

    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        tvSeriesCallCount += 1
        tvSeriesCalledWith.append(page)

        guard let stub = tvSeriesStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let tvSeries):
            return tvSeries
        case .failure(let error):
            throw error
        }
    }

    var peopleCallCount = 0
    var peopleCalledWith: [Int] = []
    var peopleStub: Result<[PersonPreview], TrendingRepositoryError>?

    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview] {
        peopleCallCount += 1
        peopleCalledWith.append(page)

        guard let stub = peopleStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let people):
            return people
        case .failure(let error):
            throw error
        }
    }

}
