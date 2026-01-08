//
//  CachedTVSeriesLocalDataSourceTVSeriesTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CachingTestHelpers
import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
import TVSeriesDomain

@testable import TVSeriesInfrastructure

@Suite("CachedTVSeriesLocalDataSource TV Series Tests")
struct CachedTVSeriesLocalDataSourceTVSeriesTests {

    let mockCache: MockCache
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockCache = MockCache()
        self.mockObservabilityProvider = MockObservabilityProvider()
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

    @Test("tvSeries with ID should create span with correct operation")
    func tvSeriesWithID_shouldCreateSpanWithCorrectOperation() async throws {
        let id = 789
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.tvSeries(withID: id)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.localDataSourceGet.value)
        #expect(mockSpan.startChildCalledWith[0].description == "Get TV Series #\(id)")
    }

    @Test("tvSeries with ID should set entity data on span")
    func tvSeriesWithID_shouldSetEntityDataOnSpan() async throws {
        let id = 101
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.tvSeries(withID: id)
        }

        #expect(mockSpan.setDataCallCount >= 2)
        let entityTypeEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_type" })
        let entityIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_id" })
        #expect(entityTypeEntry?.value == "TVSeries")
        #expect(entityIDEntry?.value == "\(id)")
    }

    @Test("tvSeries with ID should finish span")
    func tvSeriesWithID_shouldFinishSpan() async throws {
        let id = 202
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.tvSeries(withID: id)
        }

        #expect(mockSpan.finishCallCount == 1)
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

    @Test("setTVSeries should create span with correct operation")
    func setTVSeries_shouldCreateSpanWithCorrectOperation() async throws {
        let tvSeries = TVSeries.mock(id: 505)
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setTVSeries(tvSeries)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.localDataSourceSet.value)
        #expect(
            mockSpan.startChildCalledWith[0].description == "Set TV Series #\(tvSeries.id)")
    }

    @Test("setTVSeries should set entity data on span")
    func setTVSeries_shouldSetEntityDataOnSpan() async throws {
        let tvSeries = TVSeries.mock(id: 606)
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setTVSeries(tvSeries)
        }

        #expect(mockSpan.setDataCallCount >= 2)
        let entityTypeEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_type" })
        let entityIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_id" })
        #expect(entityTypeEntry?.value == "TVSeries")
        #expect(entityIDEntry?.value == "\(tvSeries.id)")
    }

    @Test("setTVSeries should finish span")
    func setTVSeries_shouldFinishSpan() async throws {
        let tvSeries = TVSeries.mock(id: 707)
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setTVSeries(tvSeries)
        }

        #expect(mockSpan.finishCallCount == 1)
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
