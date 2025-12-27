//
//  CachedTVSeriesLocalDataSourceTVSeriesTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CachingTestHelpers
import CoreDomainTestHelpers
import Foundation
import Testing
import TVSeriesDomain

@testable import TVSeriesInfrastructure

// swiftlint:disable type_name
@Suite("CachedTVSeriesLocalDataSource TV Series Tests")
struct CachedTVSeriesLocalDataSourceTVSeriesTests {
    // swiftlint:enable type_name

    let mockCache: MockCache

    init() {
        self.mockCache = MockCache()
    }

    // MARK: - tvSeries(withID:) Tests

    @Test("tvSeries with ID should return cached TV series")
    func tvSeriesWithID_shouldReturnCachedTVSeries() async throws {
        let id = 123
        let expectedTVSeries = TVSeries.mock(id: id)
        let cacheKey = CacheKey("TVKit.TVInfrastructure.tv-series-\(id)")
        await mockCache.setItem(expectedTVSeries, forKey: cacheKey)

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        let result = await dataSource.tvSeries(withID: id)

        #expect(result?.id == expectedTVSeries.id)
        #expect(await mockCache.itemCallCount == 1)
        let calledWithKey = await mockCache.itemCalledWithKeys[0]
        #expect(calledWithKey == cacheKey)
    }

    @Test("tvSeries with ID should return nil when not cached")
    func tvSeriesWithID_shouldReturnNilWhenNotCached() async throws {
        let id = 456
        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        let result = await dataSource.tvSeries(withID: id)

        #expect(result == nil)
        #expect(await mockCache.itemCallCount == 1)
    }

    @Test("tvSeries with ID should use cache with correct key")
    func tvSeriesWithID_shouldUseCacheWithCorrectKey() async throws {
        let id = 303
        let expectedCacheKey = CacheKey("TVKit.TVInfrastructure.tv-series-\(id)")

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await dataSource.tvSeries(withID: id)

        #expect(await mockCache.itemCallCount == 1)
        let calledWithKey = await mockCache.itemCalledWithKeys[0]
        #expect(calledWithKey == expectedCacheKey)
    }

    // MARK: - setTVSeries(_:) Tests

    @Test("setTVSeries should store in cache")
    func setTVSeries_shouldStoreInCache() async throws {
        let tvSeries = TVSeries.mock(id: 404)
        let expectedCacheKey = CacheKey("TVKit.TVInfrastructure.tv-series-\(tvSeries.id)")

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await dataSource.setTVSeries(tvSeries)

        #expect(await mockCache.setItemCallCount == 1)
        let calledWithKey = await mockCache.setItemCalledWithKeys[0]
        #expect(calledWithKey == expectedCacheKey)
    }

    @Test("setTVSeries should use cache with correct key")
    func setTVSeries_shouldUseCacheWithCorrectKey() async throws {
        let tvSeries = TVSeries.mock(id: 808)
        let expectedCacheKey = CacheKey("TVKit.TVInfrastructure.tv-series-\(tvSeries.id)")

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await dataSource.setTVSeries(tvSeries)

        #expect(await mockCache.setItemCallCount == 1)
        let calledWithKey = await mockCache.setItemCalledWithKeys[0]
        #expect(calledWithKey == expectedCacheKey)
    }

}
