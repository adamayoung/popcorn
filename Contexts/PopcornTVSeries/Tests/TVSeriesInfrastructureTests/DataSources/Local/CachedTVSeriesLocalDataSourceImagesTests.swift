//
//  CachedTVSeriesLocalDataSourceImagesTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CachingTestHelpers
import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("CachedTVSeriesLocalDataSource Images Tests")
struct CachedTVSeriesLocalDataSourceImagesTests {

    let mockCache: MockCache
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockCache = MockCache()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    // MARK: - images(forTVSeries:) Tests

    @Test("images for TV series should return cached image collection")
    func imagesForTVSeries_shouldReturnCachedImageCollection() async {
        let tvSeriesID = 909
        let expectedImageCollection = ImageCollection.mock(id: tvSeriesID)
        let cacheKey = CacheKey("TVKit.TVInfrastructure.tv-series-\(tvSeriesID)-images")
        await mockCache.setItem(expectedImageCollection, forKey: cacheKey)

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        let result = await dataSource.images(forTVSeries: tvSeriesID)

        #expect(result?.id == expectedImageCollection.id)
        #expect(await mockCache.itemCallCount == 1)
    }

    @Test("images for TV series should return nil when not cached")
    func imagesForTVSeries_shouldReturnNilWhenNotCached() async {
        let tvSeriesID = 1010
        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        let result = await dataSource.images(forTVSeries: tvSeriesID)

        #expect(result == nil)
        #expect(await mockCache.itemCallCount == 1)
    }

    @Test("images for TV series should create span with correct operation")
    func imagesForTVSeries_shouldCreateSpanWithCorrectOperation() async {
        let tvSeriesID = 1111
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.images(forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.localDataSourceGet.value
        )
        #expect(
            mockSpan.startChildCalledWith[0].description
                == "Get TV Series Image Collection #\(tvSeriesID)"
        )
    }

    @Test("images for TV series should set entity data on span")
    func imagesForTVSeries_shouldSetEntityDataOnSpan() async {
        let tvSeriesID = 1212
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.images(forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.setDataCallCount >= 2)
        let entityTypeEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_type" })
        let entityIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_id" })
        #expect(entityTypeEntry?.value == "imageCollection")
        #expect(entityIDEntry?.value == "\(tvSeriesID)")
    }

    @Test("images for TV series should finish span")
    func imagesForTVSeries_shouldFinishSpan() async {
        let tvSeriesID = 1313
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.images(forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.finishCallCount == 1)
    }

    // MARK: - setImages(_:forTVSeries:) Tests

    @Test("setImages should store in cache")
    func setImages_shouldStoreInCache() async {
        let tvSeriesID = 1414
        let imageCollection = ImageCollection.mock(id: tvSeriesID)
        let expectedCacheKey = CacheKey("TVKit.TVInfrastructure.tv-series-\(tvSeriesID)-images")

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await dataSource.setImages(imageCollection, forTVSeries: tvSeriesID)

        #expect(await mockCache.setItemCallCount == 1)
        let calledWithKey = await mockCache.setItemCalledWithKeys[0]
        #expect(calledWithKey == expectedCacheKey)
    }

    @Test("setImages should create span with correct operation")
    func setImages_shouldCreateSpanWithCorrectOperation() async {
        let tvSeriesID = 1515
        let imageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.localDataSourceSet.value
        )
        #expect(
            mockSpan.startChildCalledWith[0].description
                == "Set TV Series Image Collection #\(tvSeriesID)"
        )
    }

    @Test("setImages should set entity data on span")
    func setImages_shouldSetEntityDataOnSpan() async {
        let tvSeriesID = 1616
        let imageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.setDataCallCount >= 2)
        let entityTypeEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_type" })
        let entityIDEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "entity_id" })
        #expect(entityTypeEntry?.value == "imageCollection")
        #expect(entityIDEntry?.value == "\(tvSeriesID)")
    }

    @Test("setImages should finish span")
    func setImages_shouldFinishSpan() async {
        let tvSeriesID = 1717
        let imageCollection = ImageCollection.mock(id: tvSeriesID)
        let mockSpan = MockSpan()
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            await dataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
        }

        #expect(mockSpan.finishCallCount == 1)
    }

}
