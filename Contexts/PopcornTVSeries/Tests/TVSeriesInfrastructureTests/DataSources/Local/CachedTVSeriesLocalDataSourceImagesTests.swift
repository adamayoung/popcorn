//
//  CachedTVSeriesLocalDataSourceImagesTests.swift
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

@Suite("CachedTVSeriesLocalDataSource Images Tests")
struct CachedTVSeriesLocalDataSourceImagesTests {

    let mockCache: MockCache

    init() {
        self.mockCache = MockCache()
    }

    // MARK: - images(forTVSeries:) Tests

    @Test("images for TV series should return cached image collection")
    func imagesForTVSeries_shouldReturnCachedImageCollection() async throws {
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
    func imagesForTVSeries_shouldReturnNilWhenNotCached() async throws {
        let tvSeriesID = 1010
        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        let result = await dataSource.images(forTVSeries: tvSeriesID)

        #expect(result == nil)
        #expect(await mockCache.itemCallCount == 1)
    }

    // MARK: - setImages(_:forTVSeries:) Tests

    @Test("setImages should store in cache")
    func setImages_shouldStoreInCache() async throws {
        let tvSeriesID = 1414
        let imageCollection = ImageCollection.mock(id: tvSeriesID)
        let expectedCacheKey = CacheKey("TVKit.TVInfrastructure.tv-series-\(tvSeriesID)-images")

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        await dataSource.setImages(imageCollection, forTVSeries: tvSeriesID)

        #expect(await mockCache.setItemCallCount == 1)
        let calledWithKey = await mockCache.setItemCalledWithKeys[0]
        #expect(calledWithKey == expectedCacheKey)
    }

}
