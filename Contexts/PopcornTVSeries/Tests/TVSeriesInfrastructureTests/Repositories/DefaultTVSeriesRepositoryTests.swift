//
//  DefaultTVSeriesRepositoryTests.swift
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

@Suite("DefaultTVSeriesRepository Integration Tests")
struct DefaultTVSeriesRepositoryTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesLocalDataSource
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesLocalDataSource()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    @Test("works without span")
    func worksWithoutSpan() async throws {
        let id = 2424
        let tvSeries = TVSeries.mock(id: id)
        let imageCollection = ImageCollection.mock(id: id)

        mockLocalDataSource.tvSeriesWithIDStub = .success(tvSeries)
        mockLocalDataSource.imagesForTVSeriesStub = .success(imageCollection)

        SpanContext.provider = nil

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        let tvSeriesResult = try await repository.tvSeries(withID: id)
        let imagesResult = try await repository.images(forTVSeries: id)

        #expect(tvSeriesResult.id == id)
        #expect(imagesResult.id == id)
        #expect(await mockLocalDataSource.tvSeriesWithIDCallCount == 1)
        #expect(await mockLocalDataSource.imagesForTVSeriesCallCount == 1)
    }

}
