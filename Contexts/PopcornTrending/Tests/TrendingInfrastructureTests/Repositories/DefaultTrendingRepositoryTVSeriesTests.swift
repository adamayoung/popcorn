//
//  DefaultTrendingRepositoryTVSeriesTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TrendingDomain
@testable import TrendingInfrastructure

@Suite("DefaultTrendingRepository TVSeries")
struct DefaultTrendingRepositoryTVSeriesTests {

    let mockRemoteDataSource: MockTrendingRemoteDataSource

    init() {
        self.mockRemoteDataSource = MockTrendingRemoteDataSource()
    }

    @Test("tvSeries returns values from remote data source")
    func tvSeriesReturnsValuesFromRemoteDataSource() async throws {
        let tvSeriesPreviews = TVSeriesPreview.mocks
        mockRemoteDataSource.tvSeriesStub = .success(tvSeriesPreviews)

        let repository = makeRepository()

        let result = try await repository.tvSeries(page: 1)

        #expect(result == tvSeriesPreviews)
    }

    @Test("tvSeries passes page to remote data source")
    func tvSeriesPassesPageToRemoteDataSource() async throws {
        mockRemoteDataSource.tvSeriesStub = .success([])

        let repository = makeRepository()

        _ = try await repository.tvSeries(page: 2)

        #expect(mockRemoteDataSource.tvSeriesCallCount == 1)
        #expect(mockRemoteDataSource.tvSeriesCalledWith == [2])
    }

    @Test("tvSeries returns empty array when remote returns empty")
    func tvSeriesReturnsEmptyArrayWhenRemoteReturnsEmpty() async throws {
        mockRemoteDataSource.tvSeriesStub = .success([])

        let repository = makeRepository()

        let result = try await repository.tvSeries(page: 1)

        #expect(result.isEmpty)
    }

    @Test("tvSeries throws unauthorised error when remote throws unauthorised")
    func tvSeriesThrowsUnauthorisedErrorWhenRemoteThrowsUnauthorised() async {
        mockRemoteDataSource.tvSeriesStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.tvSeries(page: 1)
            },
            throws: { error in
                guard let repositoryError = error as? TrendingRepositoryError else {
                    return false
                }
                if case .unauthorised = repositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("tvSeries throws unknown error when remote throws unknown")
    func tvSeriesThrowsUnknownErrorWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRemoteDataSource.tvSeriesStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.tvSeries(page: 1)
            },
            throws: { error in
                guard let repositoryError = error as? TrendingRepositoryError else {
                    return false
                }
                if case .unknown = repositoryError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultTrendingRepository {
        DefaultTrendingRepository(remoteDataSource: mockRemoteDataSource)
    }

}
