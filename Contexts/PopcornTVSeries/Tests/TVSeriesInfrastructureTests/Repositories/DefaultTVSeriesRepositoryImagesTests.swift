//
//  DefaultTVSeriesRepositoryImagesTests.swift
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

@Suite("DefaultTVSeriesRepository Images Tests")
struct DefaultTVSeriesRepositoryImagesTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesLocalDataSource
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesLocalDataSource()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    // MARK: - images(forTVSeries:) Tests

    @Test("images for TV series should return from cache when available")
    func imagesForTVSeries_shouldReturnFromCacheWhenAvailable() async throws {
        let tvSeriesID = 1212
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        mockLocalDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        let result = try await repository.images(forTVSeries: tvSeriesID)

        #expect(result.id == expectedImageCollection.id)
        #expect(await mockLocalDataSource.imagesForTVSeriesCallCount == 1)
        #expect(mockRemoteDataSource.imagesForTVSeriesCallCount == 0)
    }

    @Test("images for TV series should set cache hit true on span")
    func imagesForTVSeries_shouldSetCacheHitTrueOnSpan() async throws {
        let tvSeriesID = 1313
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockLocalDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.images(forTVSeries: tvSeriesID)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "cache.hit" })
        #expect(cacheHitEntry?.value == "true")
    }

    @Test("images for TV series should fetch from remote on cache miss")
    func imagesForTVSeries_shouldFetchFromRemoteOnCacheMiss() async throws {
        let tvSeriesID = 1414
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        mockLocalDataSource.imagesForTVSeriesStub = .success(nil)
        mockRemoteDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        let result = try await repository.images(forTVSeries: tvSeriesID)

        #expect(result.id == expectedImageCollection.id)
        #expect(await mockLocalDataSource.imagesForTVSeriesCallCount == 1)
        #expect(mockRemoteDataSource.imagesForTVSeriesCallCount == 1)
    }

    @Test("images for TV series should set cache hit false on span")
    func imagesForTVSeries_shouldSetCacheHitFalseOnSpan() async throws {
        let tvSeriesID = 1515
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockLocalDataSource.imagesForTVSeriesStub = .success(nil)
        mockRemoteDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.images(forTVSeries: tvSeriesID)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "cache.hit" })
        #expect(cacheHitEntry?.value == "false")
    }

    @Test("images for TV series should cache remote result")
    func imagesForTVSeries_shouldCacheRemoteResult() async throws {
        let tvSeriesID = 1616
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        mockLocalDataSource.imagesForTVSeriesStub = .success(nil)
        mockRemoteDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await repository.images(forTVSeries: tvSeriesID)

        #expect(await mockLocalDataSource.setImagesCallCount == 1)
        let cachedImageCollection = await mockLocalDataSource.setImagesCalledWith[0]
        #expect(cachedImageCollection.imageCollection.id == expectedImageCollection.id)
    }

    @Test("images for TV series should create span with correct operation")
    func imagesForTVSeries_shouldCreateSpanWithCorrectOperation() async throws {
        let tvSeriesID = 1717
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockLocalDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.images(forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value == SpanOperation.repositoryGet.value)
        #expect(
            mockSpan.startChildCalledWith[0].description == "Fetch TV Series Images #\(tvSeriesID)")
    }

    @Test("images for TV series should set entity data on span")
    func imagesForTVSeries_shouldSetEntityDataOnSpan() async throws {
        let tvSeriesID = 1818
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockLocalDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.images(forTVSeries: tvSeriesID)
        }

        let entityTypeEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_type" })
        let entityIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_id" })
        #expect(entityTypeEntry?.value == "ImageCollection")
        #expect(entityIDEntry?.value == "\(tvSeriesID)")
    }

    @Test("images for TV series should finish span with ok status on success")
    func imagesForTVSeries_shouldFinishSpanWithOkStatusOnSuccess() async throws {
        let tvSeriesID = 1919
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockLocalDataSource.imagesForTVSeriesStub = .success(expectedImageCollection)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.images(forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("images for TV series should throw on remote error")
    func imagesForTVSeries_shouldThrowOnRemoteError() async throws {
        let tvSeriesID = 2020
        mockLocalDataSource.imagesForTVSeriesStub = .success(nil)
        mockRemoteDataSource.imagesForTVSeriesStub = .failure(.notFound)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.images(forTVSeries: tvSeriesID)
            },
            throws: { error in
                if case .notFound = error as? TVSeriesRepositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("images for TV series should set error on span and finish with internal error on remote failure")
    func imagesForTVSeries_shouldSetErrorOnSpanAndFinishWithInternalErrorOnRemoteFailure()
    async throws {
        let tvSeriesID = 2121
        let mockSpan = MockSpan()
        mockLocalDataSource.imagesForTVSeriesStub = .success(nil)
        mockRemoteDataSource.imagesForTVSeriesStub = .failure(.notFound)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await repository.images(forTVSeries: tvSeriesID)
                }
            },
            throws: { _ in true }
        )

        let errorEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "error" })
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("images for TV series should throw on local cache error")
    func imagesForTVSeries_shouldThrowOnLocalCacheError() async throws {
        let tvSeriesID = 2222
        mockLocalDataSource.imagesForTVSeriesStub = .failure(.unknown())

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.images(forTVSeries: tvSeriesID)
            },
            throws: { error in
                error is TVSeriesRepositoryError
            }
        )
    }

    @Test("images for TV series should throw on local cache save error")
    func imagesForTVSeries_shouldThrowOnLocalCacheSaveError() async throws {
        let tvSeriesID = 2323
        let imageCollection = ImageCollection.mock(id: tvSeriesID)
        mockLocalDataSource.imagesForTVSeriesStub = .success(nil)
        mockLocalDataSource.setImagesStub = .failure(.unknown())
        mockRemoteDataSource.imagesForTVSeriesStub = .success(imageCollection)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        await #expect(
            performing: {
                try await repository.images(forTVSeries: tvSeriesID)
            },
            throws: { error in
                error is TVSeriesRepositoryError
            }
        )
    }

}
