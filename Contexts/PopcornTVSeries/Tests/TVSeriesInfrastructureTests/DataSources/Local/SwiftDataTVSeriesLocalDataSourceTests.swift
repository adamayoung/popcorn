//
//  SwiftDataTVSeriesLocalDataSourceTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("SwiftDataTVSeriesLocalDataSource")
struct SwiftDataTVSeriesLocalDataSourceTests {

    let modelContainer: ModelContainer

    init() throws {
        let schema = Schema([
            TVSeriesEntity.self,
            TVSeriesSeasonEntity.self,
            TVSeriesImageCollectionEntity.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
    }

    // MARK: - tvSeries() Tests

    @Test("tvSeries returns nil when cache is empty")
    func tvSeriesReturnsNilWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.tvSeries(withID: 1396)

        #expect(result == nil)
    }

    @Test("tvSeries returns cached tv series when available")
    func tvSeriesReturnsCachedTVSeriesWhenAvailable() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)
        let tvSeries = TVSeries.mock()

        try await dataSource.setTVSeries(tvSeries)
        let result = try await dataSource.tvSeries(withID: tvSeries.id)

        #expect(result != nil)
        #expect(result?.id == tvSeries.id)
        #expect(result?.name == tvSeries.name)
    }

    @Test("tvSeries returns nil for different ID")
    func tvSeriesReturnsNilForDifferentID() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setTVSeries(TVSeries.mock())
        let result = try await dataSource.tvSeries(withID: 9999)

        #expect(result == nil)
    }

    @Test("tvSeries preserves all fields")
    func tvSeriesPreservesAllFields() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)
        let tvSeries = TVSeries.mock(
            id: 42,
            name: "Test Series",
            overview: "Test overview"
        )

        try await dataSource.setTVSeries(tvSeries)
        let result = try await dataSource.tvSeries(withID: 42)

        let retrieved = try #require(result)
        #expect(retrieved.id == 42)
        #expect(retrieved.name == "Test Series")
        #expect(retrieved.overview == "Test overview")
    }

    // MARK: - setTVSeries() upsert Tests

    @Test("setTVSeries updates existing entry")
    func setTVSeriesUpdatesExistingEntry() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)
        let original = TVSeries.mock(name: "Original Name")
        let updated = TVSeries.mock(name: "Updated Name")

        try await dataSource.setTVSeries(original)
        try await dataSource.setTVSeries(updated)
        let result = try await dataSource.tvSeries(withID: original.id)

        #expect(result?.name == "Updated Name")
    }

    // MARK: - images() Tests

    @Test("images returns nil when cache is empty")
    func imagesReturnsNilWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.images(forTVSeries: 1396)

        #expect(result == nil)
    }

    @Test("images returns cached image collection when available")
    func imagesReturnsCachedImageCollectionWhenAvailable() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)
        let images = ImageCollection.mock()

        try await dataSource.setImages(images, forTVSeries: 1396)
        let result = try await dataSource.images(forTVSeries: 1396)

        #expect(result != nil)
        #expect(result?.posterPaths.count == images.posterPaths.count)
        #expect(result?.backdropPaths.count == images.backdropPaths.count)
        #expect(result?.logoPaths.count == images.logoPaths.count)
    }

    @Test("images returns nil for different TV series ID")
    func imagesReturnsNilForDifferentID() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setImages(ImageCollection.mock(), forTVSeries: 1396)
        let result = try await dataSource.images(forTVSeries: 9999)

        #expect(result == nil)
    }

    // MARK: - setImages() upsert Tests

    @Test("setImages updates existing entry")
    func setImagesUpdatesExistingEntry() async throws {
        let dataSource = SwiftDataTVSeriesLocalDataSource(modelContainer: modelContainer)
        let oldURL = try #require(URL(string: "/old.jpg"))
        let newURL = try #require(URL(string: "/new.jpg"))
        let original = ImageCollection.mock(posterPaths: [oldURL])
        let updated = ImageCollection.mock(posterPaths: [newURL])

        try await dataSource.setImages(original, forTVSeries: 1396)
        try await dataSource.setImages(updated, forTVSeries: 1396)
        let result = try await dataSource.images(forTVSeries: 1396)

        #expect(result?.posterPaths == [newURL])
    }

}
