//
//  DefaultTVSeriesRepositoryTVSeriesTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import Testing
import TVSeriesDomain

@testable import TVSeriesInfrastructure

@Suite("DefaultTVSeriesRepository TV Series Tests")
struct DefaultTVSeriesRepositoryTVSeriesTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesLocalDataSource

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesLocalDataSource()
    }

    // MARK: - tvSeries(withID:) Tests

    @Test("tvSeries with ID should return from cache when available")
    func tvSeriesWithID_shouldReturnFromCacheWhenAvailable() async throws {
        let id = 123
        let expectedTVSeries = TVSeries.mock(id: id)
        mockLocalDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        let result = try await repository.tvSeries(withID: id)

        #expect(result.id == expectedTVSeries.id)
        #expect(await mockLocalDataSource.tvSeriesWithIDCallCount == 1)
        #expect(mockRemoteDataSource.tvSeriesWithIDCallCount == 0)
    }

    @Test("tvSeries with ID should fetch from remote on cache miss")
    func tvSeriesWithID_shouldFetchFromRemoteOnCacheMiss() async throws {
        let id = 789
        let expectedTVSeries = TVSeries.mock(id: id)
        mockLocalDataSource.tvSeriesWithIDStub = .success(nil)
        mockRemoteDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        let result = try await repository.tvSeries(withID: id)

        #expect(result.id == expectedTVSeries.id)
        #expect(await mockLocalDataSource.tvSeriesWithIDCallCount == 1)
        #expect(mockRemoteDataSource.tvSeriesWithIDCallCount == 1)
    }

    @Test("tvSeries with ID should cache remote result")
    func tvSeriesWithID_shouldCacheRemoteResult() async throws {
        let id = 202
        let expectedTVSeries = TVSeries.mock(id: id)
        mockLocalDataSource.tvSeriesWithIDStub = .success(nil)
        mockRemoteDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await repository.tvSeries(withID: id)

        #expect(await mockLocalDataSource.setTVSeriesCallCount == 1)
        let cachedTVSeries = await mockLocalDataSource.setTVSeriesCalledWith[0]
        #expect(cachedTVSeries.id == expectedTVSeries.id)
    }

    @Test("tvSeries with ID should throw on remote error")
    func tvSeriesWithID_shouldThrowOnRemoteError() async throws {
        let id = 606
        mockLocalDataSource.tvSeriesWithIDStub = .success(nil)
        mockRemoteDataSource.tvSeriesWithIDStub = .failure(.notFound)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.tvSeries(withID: id)
            },
            throws: { error in
                if case .notFound = error as? TVSeriesRepositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("tvSeries with ID should map remote error correctly")
    func tvSeriesWithID_shouldMapRemoteErrorCorrectly() async throws {
        let id = 707
        mockLocalDataSource.tvSeriesWithIDStub = .success(nil)

        // Test notFound mapping
        mockRemoteDataSource.tvSeriesWithIDStub = .failure(.notFound)
        let repository1 = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
        await #expect(
            performing: { try await repository1.tvSeries(withID: id) },
            throws: { error in
                if case .notFound = error as? TVSeriesRepositoryError {
                    return true
                }
                return false
            }
        )

        // Test unauthorised mapping
        mockRemoteDataSource.tvSeriesWithIDStub = .failure(.unauthorised)
        let repository2 = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
        await #expect(
            performing: { try await repository2.tvSeries(withID: id) },
            throws: { error in
                if case .unauthorised = error as? TVSeriesRepositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("tvSeries with ID should throw on local cache error")
    func tvSeriesWithID_shouldThrowOnLocalCacheError() async throws {
        let id = 909
        mockLocalDataSource.tvSeriesWithIDStub = .failure(.unknown())

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.tvSeries(withID: id)
            },
            throws: { error in
                error is TVSeriesRepositoryError
            }
        )
    }

    @Test("tvSeries with ID should throw on local cache save error")
    func tvSeriesWithID_shouldThrowOnLocalCacheSaveError() async throws {
        let id = 1010
        let tvSeries = TVSeries.mock(id: id)
        mockLocalDataSource.tvSeriesWithIDStub = .success(nil)
        mockLocalDataSource.setTVSeriesStub = .failure(.unknown())
        mockRemoteDataSource.tvSeriesWithIDStub = .success(tvSeries)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.tvSeries(withID: id)
            },
            throws: { error in
                error is TVSeriesRepositoryError
            }
        )
    }

    @Test("tvSeries with ID should map local error correctly")
    func tvSeriesWithID_shouldMapLocalErrorCorrectly() async throws {
        let id = 1111
        mockLocalDataSource.tvSeriesWithIDStub = .failure(.persistence(NSError(domain: "test", code: 1)))

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.tvSeries(withID: id)
            },
            throws: { error in
                error is TVSeriesRepositoryError
            }
        )
    }

}
