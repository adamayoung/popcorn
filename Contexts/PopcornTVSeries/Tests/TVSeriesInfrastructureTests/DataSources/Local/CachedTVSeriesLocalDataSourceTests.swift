//
//  CachedTVSeriesLocalDataSourceTests.swift
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

@Suite("CachedTVSeriesLocalDataSource Integration Tests")
struct CachedTVSeriesLocalDataSourceTests {

    let mockCache: MockCache
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockCache = MockCache()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    @Test("works without span")
    func worksWithoutSpan() async throws {
        let id = 1818
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)

        SpanContext.provider = nil

        let dataSource = CachedTVSeriesLocalDataSource(cache: mockCache)

        _ = try await dataSource.tvSeries(withID: id)
        try await dataSource.setTVSeries(tvSeries)
        _ = try await dataSource.images(forTVSeries: id)
        try await dataSource.setImages(imageCollection, forTVSeries: id)

        #expect(await mockCache.itemCallCount == 2)
        #expect(await mockCache.setItemCallCount == 2)
    }

}
