//
//  TVEpisodeDetailsCacheEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("TVEpisodeDetailsCacheEntityMapper")
struct TVEpisodeDetailsCacheEntityMapperTests {

    let mapper = TVEpisodeDetailsCacheEntityMapper()

    // MARK: - map(entity) → TVEpisode

    @Test("map entity to domain maps all properties")
    func mapEntityToDomain_mapsAllProperties() {
        let entity = TVEpisodeDetailsCacheEntity.makeEntity()

        let result = mapper.map(entity)

        #expect(result.id == entity.episodeID)
        #expect(result.name == entity.name)
        #expect(result.episodeNumber == entity.episodeNumber)
        #expect(result.seasonNumber == entity.seasonNumber)
        #expect(result.overview == entity.overview)
        #expect(result.airDate == entity.airDate)
        #expect(result.runtime == entity.runtime)
        #expect(result.stillPath == entity.stillPath)
    }

    @Test("map entity to domain with nil optionals")
    func mapEntityToDomain_withNilOptionals() {
        let entity = TVEpisodeDetailsCacheEntity.makeEntity(
            overview: nil,
            airDate: nil,
            runtime: nil,
            stillPath: nil
        )

        let result = mapper.map(entity)

        #expect(result.overview == nil)
        #expect(result.airDate == nil)
        #expect(result.runtime == nil)
        #expect(result.stillPath == nil)
    }

    // MARK: - map(TVEpisode, tvSeriesID:) → entity

    @Test("map domain to entity maps all properties")
    func mapDomainToEntity_mapsAllProperties() {
        let episode = TVEpisode.mock()

        let result = mapper.map(episode, tvSeriesID: 1396)

        #expect(result.compositeKey == "1396-1-1")
        #expect(result.tvSeriesID == 1396)
        #expect(result.episodeID == episode.id)
        #expect(result.name == episode.name)
        #expect(result.episodeNumber == episode.episodeNumber)
        #expect(result.seasonNumber == episode.seasonNumber)
        #expect(result.overview == episode.overview)
        #expect(result.airDate == episode.airDate)
        #expect(result.runtime == episode.runtime)
        #expect(result.stillPath == episode.stillPath)
    }

    @Test("map domain to entity generates correct composite key")
    func mapDomainToEntity_generatesCorrectCompositeKey() {
        let episode = TVEpisode(
            id: 999,
            name: "Episode 5",
            episodeNumber: 5,
            seasonNumber: 3
        )

        let result = mapper.map(episode, tvSeriesID: 456)

        #expect(result.compositeKey == "456-3-5")
    }

    // MARK: - map(TVEpisode, to:)

    @Test("map domain to existing entity updates properties")
    func mapDomainToExistingEntity_updatesProperties() {
        let entity = TVEpisodeDetailsCacheEntity.makeEntity()
        let updatedAirDate = Date(timeIntervalSince1970: 1_300_000_000)
        let updatedEpisode = TVEpisode(
            id: entity.episodeID,
            name: "Updated Name",
            episodeNumber: 5,
            seasonNumber: 2,
            overview: "Updated overview",
            airDate: updatedAirDate,
            runtime: 55,
            stillPath: URL(string: "/updated-still.jpg")
        )

        mapper.map(updatedEpisode, to: entity)

        #expect(entity.name == "Updated Name")
        #expect(entity.episodeNumber == 5)
        #expect(entity.seasonNumber == 2)
        #expect(entity.overview == "Updated overview")
        #expect(entity.airDate == updatedAirDate)
        #expect(entity.runtime == 55)
        #expect(entity.stillPath == URL(string: "/updated-still.jpg"))
    }

    @Test("map domain to existing entity updates cachedAt")
    func mapDomainToExistingEntity_updatesCachedAt() {
        let oldDate = Date(timeIntervalSince1970: 1_000_000_000)
        let entity = TVEpisodeDetailsCacheEntity.makeEntity(cachedAt: oldDate)

        mapper.map(TVEpisode.mock(), to: entity)

        #expect(entity.cachedAt > oldDate)
    }

}

// MARK: - Composite Key

@Suite("TVEpisodeDetailsCacheEntity Composite Key")
struct TVEpisodeDetailsCacheEntityCompositeKeyTests {

    @Test("makeCompositeKey generates correct format")
    func makeCompositeKey_generatesCorrectFormat() {
        let key = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: 1396,
            seasonNumber: 2,
            episodeNumber: 3
        )

        #expect(key == "1396-2-3")
    }

    @Test("makeCompositeKey produces unique keys for different episodes")
    func makeCompositeKey_producesUniqueKeys() {
        let key1 = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1
        )
        let key2 = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 2
        )
        let key3 = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: 1396, seasonNumber: 2, episodeNumber: 1
        )

        #expect(key1 != key2)
        #expect(key1 != key3)
        #expect(key2 != key3)
    }

}

extension TVEpisodeDetailsCacheEntity {

    static func makeEntity(
        tvSeriesID: Int = 1396,
        episodeID: Int = 62085,
        name: String = "Pilot",
        episodeNumber: Int = 1,
        seasonNumber: Int = 1,
        overview: String? = "A chemistry teacher begins cooking meth.",
        airDate: Date? = Date(timeIntervalSince1970: 1_200_000_000),
        runtime: Int? = 58,
        stillPath: URL? = URL(string: "/still.jpg"),
        cachedAt: Date = Date.now
    ) -> TVEpisodeDetailsCacheEntity {
        let key = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber
        )
        return TVEpisodeDetailsCacheEntity(
            compositeKey: key,
            tvSeriesID: tvSeriesID,
            episodeID: episodeID,
            name: name,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            runtime: runtime,
            stillPath: stillPath,
            cachedAt: cachedAt
        )
    }

}
