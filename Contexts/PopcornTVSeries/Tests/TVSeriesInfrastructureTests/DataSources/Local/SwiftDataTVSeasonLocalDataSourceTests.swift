//
//  SwiftDataTVSeasonLocalDataSourceTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("SwiftDataTVSeasonLocalDataSource")
struct SwiftDataTVSeasonLocalDataSourceTests {

    let modelContainer: ModelContainer

    init() throws {
        let schema = Schema([
            TVSeasonEpisodesEntity.self,
            TVEpisodeEntity.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
    }

    // MARK: - season() Tests

    @Test("season returns nil when cache is empty")
    func seasonReturnsNilWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataTVSeasonLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.season(1, inTVSeries: 1396)

        #expect(result == nil)
    }

    @Test("season returns cached season when available")
    func seasonReturnsCachedSeasonWhenAvailable() async throws {
        let dataSource = SwiftDataTVSeasonLocalDataSource(modelContainer: modelContainer)
        let season = TVSeason.mock()

        try await dataSource.setSeason(season, inTVSeries: 1396)
        let result = try await dataSource.season(
            season.seasonNumber, inTVSeries: 1396
        )

        #expect(result != nil)
        #expect(result?.id == season.id)
        #expect(result?.name == season.name)
        #expect(result?.seasonNumber == season.seasonNumber)
    }

    @Test("season returns nil for different season number")
    func seasonReturnsNilForDifferentSeasonNumber() async throws {
        let dataSource = SwiftDataTVSeasonLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setSeason(TVSeason.mock(seasonNumber: 1), inTVSeries: 1396)
        let result = try await dataSource.season(2, inTVSeries: 1396)

        #expect(result == nil)
    }

    @Test("season returns nil for different TV series ID")
    func seasonReturnsNilForDifferentTVSeriesID() async throws {
        let dataSource = SwiftDataTVSeasonLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setSeason(TVSeason.mock(), inTVSeries: 1396)
        let result = try await dataSource.season(1, inTVSeries: 9999)

        #expect(result == nil)
    }

    @Test("season preserves all fields including episodes")
    func seasonPreservesAllFieldsIncludingEpisodes() async throws {
        let dataSource = SwiftDataTVSeasonLocalDataSource(modelContainer: modelContainer)
        let season = TVSeason.mock(
            id: 3572,
            name: "Season 1",
            seasonNumber: 1,
            overview: "The first season.",
            episodes: [
                TVEpisode.mock(id: 1, name: "Pilot", episodeNumber: 1),
                TVEpisode.mock(id: 2, name: "Second", episodeNumber: 2)
            ]
        )

        try await dataSource.setSeason(season, inTVSeries: 1396)
        let result = try await dataSource.season(1, inTVSeries: 1396)

        let retrieved = try #require(result)
        #expect(retrieved.id == 3572)
        #expect(retrieved.name == "Season 1")
        #expect(retrieved.overview == "The first season.")
        #expect(retrieved.episodes.count == 2)

        let sortedEpisodes = retrieved.episodes.sorted {
            $0.episodeNumber < $1.episodeNumber
        }
        #expect(sortedEpisodes[0].name == "Pilot")
        #expect(sortedEpisodes[1].name == "Second")
    }

    // MARK: - setSeason() upsert Tests

    @Test("setSeason updates existing entry")
    func setSeasonUpdatesExistingEntry() async throws {
        let dataSource = SwiftDataTVSeasonLocalDataSource(modelContainer: modelContainer)
        let original = TVSeason.mock(overview: "Original overview")
        let updated = TVSeason.mock(overview: "Updated overview")

        try await dataSource.setSeason(original, inTVSeries: 1396)
        try await dataSource.setSeason(updated, inTVSeries: 1396)
        let result = try await dataSource.season(1, inTVSeries: 1396)

        #expect(result?.overview == "Updated overview")
    }

    @Test("setSeason stores seasons for different TV series separately")
    func setSeasonStoresForDifferentTVSeriesSeparately() async throws {
        let dataSource = SwiftDataTVSeasonLocalDataSource(modelContainer: modelContainer)
        let season1 = TVSeason.mock(
            id: 100,
            name: "Series A Season 1",
            episodes: [TVEpisode.mock(id: 101, name: "A Pilot", episodeNumber: 1)]
        )
        let season2 = TVSeason.mock(
            id: 200,
            name: "Series B Season 1",
            episodes: [TVEpisode.mock(id: 201, name: "B Pilot", episodeNumber: 1)]
        )

        try await dataSource.setSeason(season1, inTVSeries: 100)
        try await dataSource.setSeason(season2, inTVSeries: 200)

        let result1 = try await dataSource.season(1, inTVSeries: 100)
        let result2 = try await dataSource.season(1, inTVSeries: 200)

        #expect(result1?.name == "Series A Season 1")
        #expect(result2?.name == "Series B Season 1")
    }

}
