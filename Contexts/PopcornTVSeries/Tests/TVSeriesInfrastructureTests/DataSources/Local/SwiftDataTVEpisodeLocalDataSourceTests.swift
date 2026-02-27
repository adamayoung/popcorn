//
//  SwiftDataTVEpisodeLocalDataSourceTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("SwiftDataTVEpisodeLocalDataSource")
struct SwiftDataTVEpisodeLocalDataSourceTests {

    let modelContainer: ModelContainer

    init() throws {
        let schema = Schema([
            TVEpisodeDetailsCacheEntity.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
    }

    // MARK: - episode() Tests

    @Test("episode returns nil when cache is empty")
    func episodeReturnsNilWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result == nil)
    }

    @Test("episode returns cached episode when available")
    func episodeReturnsCachedEpisodeWhenAvailable() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)
        let episode = TVEpisode.mock()

        try await dataSource.setEpisode(episode, inTVSeries: 1396)
        let result = try await dataSource.episode(
            episode.episodeNumber, inSeason: episode.seasonNumber, inTVSeries: 1396
        )

        #expect(result != nil)
        #expect(result?.id == episode.id)
        #expect(result?.name == episode.name)
    }

    @Test("episode returns nil for different episode number")
    func episodeReturnsNilForDifferentEpisodeNumber() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setEpisode(
            TVEpisode.mock(episodeNumber: 1), inTVSeries: 1396
        )
        let result = try await dataSource.episode(2, inSeason: 1, inTVSeries: 1396)

        #expect(result == nil)
    }

    @Test("episode returns nil for different season number")
    func episodeReturnsNilForDifferentSeasonNumber() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setEpisode(
            TVEpisode.mock(seasonNumber: 1), inTVSeries: 1396
        )
        let result = try await dataSource.episode(1, inSeason: 2, inTVSeries: 1396)

        #expect(result == nil)
    }

    @Test("episode returns nil for different TV series ID")
    func episodeReturnsNilForDifferentTVSeriesID() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setEpisode(TVEpisode.mock(), inTVSeries: 1396)
        let result = try await dataSource.episode(1, inSeason: 1, inTVSeries: 9999)

        #expect(result == nil)
    }

    @Test("episode preserves all fields")
    func episodePreservesAllFields() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)
        let airDate = Date(timeIntervalSince1970: 1_200_000_000)
        let episode = TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "A chemistry teacher begins cooking meth.",
            airDate: airDate,
            runtime: 58,
            stillPath: URL(string: "/still.jpg")
        )

        try await dataSource.setEpisode(episode, inTVSeries: 1396)
        let result = try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)

        let retrieved = try #require(result)
        #expect(retrieved.id == 62085)
        #expect(retrieved.name == "Pilot")
        #expect(retrieved.episodeNumber == 1)
        #expect(retrieved.seasonNumber == 1)
        #expect(retrieved.overview == "A chemistry teacher begins cooking meth.")
        #expect(retrieved.airDate == airDate)
        #expect(retrieved.runtime == 58)
        #expect(retrieved.stillPath == URL(string: "/still.jpg"))
    }

    // MARK: - setEpisode() upsert Tests

    @Test("setEpisode updates existing entry")
    func setEpisodeUpdatesExistingEntry() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)
        let original = TVEpisode.mock(overview: "Original overview")
        let updated = TVEpisode.mock(overview: "Updated overview")

        try await dataSource.setEpisode(original, inTVSeries: 1396)
        try await dataSource.setEpisode(updated, inTVSeries: 1396)
        let result = try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result?.overview == "Updated overview")
    }

    @Test("setEpisode stores episodes for different TV series separately")
    func setEpisodeStoresForDifferentTVSeriesSeparately() async throws {
        let dataSource = SwiftDataTVEpisodeLocalDataSource(modelContainer: modelContainer)
        let episode1 = TVEpisode.mock(id: 100, name: "Series A Pilot")
        let episode2 = TVEpisode.mock(id: 200, name: "Series B Pilot")

        try await dataSource.setEpisode(episode1, inTVSeries: 100)
        try await dataSource.setEpisode(episode2, inTVSeries: 200)

        let result1 = try await dataSource.episode(1, inSeason: 1, inTVSeries: 100)
        let result2 = try await dataSource.episode(1, inSeason: 1, inTVSeries: 200)

        #expect(result1?.name == "Series A Pilot")
        #expect(result2?.name == "Series B Pilot")
    }

}
