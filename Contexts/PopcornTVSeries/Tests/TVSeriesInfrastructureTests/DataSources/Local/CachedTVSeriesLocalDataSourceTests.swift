//
//  CachedTVSeriesLocalDataSourceTests.swift
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

@Suite("CachedTVSeriesLocalDataSource Integration Tests")
struct CachedTVSeriesLocalDataSourceTests {

    let mockCache: MockCache

    init() {
        self.mockCache = MockCache()
    }

    @Test("all operations work correctly")
    func allOperationsWorkCorrectly() async throws {
        let id = 1818
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = await dataSource.tvSeries(withID: id)
        await dataSource.setTVSeries(tvSeries)
        _ = await dataSource.images(forTVSeries: id)
        await dataSource.setImages(imageCollection, forTVSeries: id)

        #expect(await mockCache.itemCallCount == 2)
        #expect(await mockCache.setItemCallCount == 2)
    }

}
