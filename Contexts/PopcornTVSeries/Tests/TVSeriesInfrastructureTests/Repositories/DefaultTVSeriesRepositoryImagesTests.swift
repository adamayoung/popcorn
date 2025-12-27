//
//  DefaultTVSeriesRepositoryImagesTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import Testing
import TVSeriesDomain

@testable import TVSeriesInfrastructure

@Suite("DefaultTVSeriesRepository Images Tests")
struct DefaultTVSeriesRepositoryImagesTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesLocalDataSource

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesLocalDataSource()
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
