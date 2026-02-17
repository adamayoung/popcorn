//
//  MockDiscoverRemoteDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import DiscoverInfrastructure
import Foundation

final class MockDiscoverRemoteDataSource: DiscoverRemoteDataSource, @unchecked Sendable {

    var moviesCallCount = 0
    var moviesCalledWith: [(filter: MovieFilter?, page: Int)] = []
    var moviesStub: Result<[MoviePreview], DiscoverRemoteDataSourceError>?

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [MoviePreview] {
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

    var tvSeriesCallCount = 0
    var tvSeriesCalledWith: [(filter: TVSeriesFilter?, page: Int)] = []
    var tvSeriesStub: Result<[TVSeriesPreview], DiscoverRemoteDataSourceError>?

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview] {
        tvSeriesCallCount += 1
        tvSeriesCalledWith.append((filter: filter, page: page))

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

}
