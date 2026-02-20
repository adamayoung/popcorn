//
//  TVSeasonEpisodesEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("TVSeasonEpisodesEntityMapper")
struct TVSeasonEpisodesEntityMapperTests {

    let mapper = TVSeasonEpisodesEntityMapper()

    // MARK: - map(entity) → TVSeason

    @Test("map entity to domain maps all properties")
    func mapEntityToDomain_mapsAllProperties() {
        let entity = TVSeasonEpisodesEntity.makeEntity()

        let result = mapper.map(entity)

        #expect(result.id == entity.seasonID)
        #expect(result.name == entity.seasonName)
        #expect(result.seasonNumber == entity.seasonNumber)
        #expect(result.overview == entity.overview)
        #expect(result.episodes.count == entity.episodes.count)
    }

    @Test("map entity to domain sorts episodes by number")
    func mapEntityToDomain_sortsEpisodesByNumber() {
        let episode3 = TVEpisodeEntity.makeEntity(episodeID: 3, name: "Ep 3", episodeNumber: 3)
        let episode1 = TVEpisodeEntity.makeEntity(episodeID: 1, name: "Ep 1", episodeNumber: 1)
        let episode2 = TVEpisodeEntity.makeEntity(episodeID: 2, name: "Ep 2", episodeNumber: 2)
        let entity = TVSeasonEpisodesEntity.makeEntity(
            episodes: [episode3, episode1, episode2]
        )

        let result = mapper.map(entity)

        #expect(result.episodes[0].episodeNumber == 1)
        #expect(result.episodes[1].episodeNumber == 2)
        #expect(result.episodes[2].episodeNumber == 3)
    }

    @Test("map entity to domain with nil overview")
    func mapEntityToDomain_withNilOverview() {
        let entity = TVSeasonEpisodesEntity.makeEntity(overview: nil)

        let result = mapper.map(entity)

        #expect(result.overview == nil)
    }

    @Test("map entity to domain with empty episodes")
    func mapEntityToDomain_withEmptyEpisodes() {
        let entity = TVSeasonEpisodesEntity.makeEntity(episodes: [])

        let result = mapper.map(entity)

        #expect(result.episodes.isEmpty)
    }

    // MARK: - map(TVSeason, tvSeriesID:) → entity

    @Test("map domain to entity creates entity with correct properties")
    func mapDomainToEntity_createsEntityWithCorrectProperties() {
        let season = TVSeason(
            id: 3572,
            name: "Season 1",
            seasonNumber: 1,
            overview: "Season overview",
            episodes: [TVEpisode.mock(id: 1), TVEpisode.mock(id: 2)]
        )

        let result = mapper.map(season, tvSeriesID: 1396)

        #expect(result.compositeKey == "1396-1")
        #expect(result.tvSeriesID == 1396)
        #expect(result.seasonID == 3572)
        #expect(result.seasonName == "Season 1")
        #expect(result.seasonNumber == 1)
        #expect(result.overview == "Season overview")
        #expect(result.episodes.count == 2)
    }

    @Test("map domain to entity generates correct composite key")
    func mapDomainToEntity_generatesCorrectCompositeKey() {
        let season = TVSeason(
            id: 999,
            name: "Season 3",
            seasonNumber: 3
        )

        let result = mapper.map(season, tvSeriesID: 456)

        #expect(result.compositeKey == "456-3")
    }

    // MARK: - map(TVSeason, to:)

    @Test("map domain to existing entity updates properties")
    func mapDomainToExistingEntity_updatesProperties() {
        let entity = TVSeasonEpisodesEntity.makeEntity()
        let updatedSeason = TVSeason(
            id: 3572,
            name: "Updated Season",
            seasonNumber: 1,
            overview: "New overview",
            episodes: [TVEpisode.mock(id: 99, name: "New Episode")]
        )

        mapper.map(updatedSeason, to: entity)

        #expect(entity.seasonName == "Updated Season")
        #expect(entity.overview == "New overview")
        #expect(entity.episodes.count == 1)
        #expect(entity.episodes[0].name == "New Episode")
    }

}

extension TVSeasonEpisodesEntity {

    static func makeEntity(
        tvSeriesID: Int = 1396,
        seasonID: Int = 3572,
        seasonName: String = "Season 1",
        seasonNumber: Int = 1,
        overview: String? = "The first season of Breaking Bad.",
        episodes: [TVEpisodeEntity]? = nil
    ) -> TVSeasonEpisodesEntity {
        let key = TVSeasonEpisodesEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber
        )
        let episodeList = episodes ?? [
            TVEpisodeEntity.makeEntity(episodeID: 1, name: "Pilot", episodeNumber: 1),
            TVEpisodeEntity.makeEntity(episodeID: 2, name: "Cat's in the Bag...", episodeNumber: 2)
        ]
        return TVSeasonEpisodesEntity(
            compositeKey: key,
            tvSeriesID: tvSeriesID,
            seasonID: seasonID,
            seasonName: seasonName,
            seasonNumber: seasonNumber,
            overview: overview,
            episodes: episodeList
        )
    }

}
