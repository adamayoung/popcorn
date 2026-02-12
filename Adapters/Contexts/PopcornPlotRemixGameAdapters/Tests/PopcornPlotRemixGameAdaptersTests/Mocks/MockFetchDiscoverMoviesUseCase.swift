//
//  MockFetchDiscoverMoviesUseCase.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverApplication
import DiscoverDomain
import Foundation

final class MockFetchDiscoverMoviesUseCase: FetchDiscoverMoviesUseCase, @unchecked Sendable {

    struct ExecuteWithFilterCall: Equatable {
        let filter: MovieFilter
    }

    var executeCallCount = 0
    var executeStub: Result<[MoviePreviewDetails], FetchDiscoverMoviesError>?

    var executeWithFilterCallCount = 0
    var executeWithFilterCalledWith: [ExecuteWithFilterCall] = []
    var executeWithFilterStub: Result<[MoviePreviewDetails], FetchDiscoverMoviesError>?

    var executeWithPageCallCount = 0
    var executeWithPageStub: Result<[MoviePreviewDetails], FetchDiscoverMoviesError>?

    var executeWithFilterAndPageCallCount = 0
    var executeWithFilterAndPageStub: Result<[MoviePreviewDetails], FetchDiscoverMoviesError>?

    func execute() async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        executeCallCount += 1

        guard let stub = executeStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func execute(filter: MovieFilter) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        executeWithFilterCallCount += 1
        executeWithFilterCalledWith.append(ExecuteWithFilterCall(filter: filter))

        guard let stub = executeWithFilterStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func execute(page: Int) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        executeWithPageCallCount += 1

        guard let stub = executeWithPageStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func execute(
        filter: MovieFilter?,
        page: Int
    ) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        executeWithFilterAndPageCallCount += 1

        guard let stub = executeWithFilterAndPageStub else {
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
