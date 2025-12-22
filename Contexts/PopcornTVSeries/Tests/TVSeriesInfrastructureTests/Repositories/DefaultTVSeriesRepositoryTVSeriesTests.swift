//
//  DefaultTVSeriesRepositoryTVSeriesTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
import TVSeriesDomain

@testable import TVSeriesInfrastructure

// swiftlint:disable type_body_length

@Suite("DefaultTVSeriesRepository TV Series Tests")
struct DefaultTVSeriesRepositoryTVSeriesTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesLocalDataSource
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesLocalDataSource()
        self.mockObservabilityProvider = MockObservabilityProvider()
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

    @Test("tvSeries with ID should set cache hit true on span")
    func tvSeriesWithID_shouldSetCacheHitTrueOnSpan() async throws {
        let id = 456
        let expectedTVSeries = TVSeries.mock(id: id)
        let mockSpan = MockSpan()
        mockLocalDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.tvSeries(withID: id)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "cache.hit" })
        #expect(cacheHitEntry?.value == "true")
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

    @Test("tvSeries with ID should set cache hit false on span")
    func tvSeriesWithID_shouldSetCacheHitFalseOnSpan() async throws {
        let id = 101
        let expectedTVSeries = TVSeries.mock(id: id)
        let mockSpan = MockSpan()
        mockLocalDataSource.tvSeriesWithIDStub = .success(nil)
        mockRemoteDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.tvSeries(withID: id)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "cache.hit" })
        #expect(cacheHitEntry?.value == "false")
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

    @Test("tvSeries with ID should create span with correct operation")
    func tvSeriesWithID_shouldCreateSpanWithCorrectOperation() async throws {
        let id = 303
        let expectedTVSeries = TVSeries.mock(id: id)
        let mockSpan = MockSpan()
        mockLocalDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.tvSeries(withID: id)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value == SpanOperation.repositoryGet.value)
        #expect(mockSpan.startChildCalledWith[0].description == "Fetch TV Series #\(id)")
    }

    @Test("tvSeries with ID should set entity data on span")
    func tvSeriesWithID_shouldSetEntityDataOnSpan() async throws {
        let id = 404
        let expectedTVSeries = TVSeries.mock(id: id)
        let mockSpan = MockSpan()
        mockLocalDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.tvSeries(withID: id)
        }

        let entityTypeEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_type" })
        let entityIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_id" })
        #expect(entityTypeEntry?.value == "TVSeries")
        #expect(entityIDEntry?.value == "\(id)")
    }

    @Test("tvSeries with ID should finish span with ok status on success")
    func tvSeriesWithID_shouldFinishSpanWithOkStatusOnSuccess() async throws {
        let id = 505
        let expectedTVSeries = TVSeries.mock(id: id)
        let mockSpan = MockSpan()
        mockLocalDataSource.tvSeriesWithIDStub = .success(expectedTVSeries)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.tvSeries(withID: id)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
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

    @Test("tvSeries with ID should set error on span and finish with internal error on remote failure")
    func tvSeriesWithID_shouldSetErrorOnSpanAndFinishWithInternalErrorOnRemoteFailure()
    async throws {
        let id = 808
        let mockSpan = MockSpan()
        mockLocalDataSource.tvSeriesWithIDStub = .success(nil)
        mockRemoteDataSource.tvSeriesWithIDStub = .failure(.notFound)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await repository.tvSeries(withID: id)
                }
            },
            throws: { _ in true }
        )

        let errorEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "error" })
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
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

// swiftlint:enable type_body_length
