//
//  TVEpisodeEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("TVEpisodeEntityMapper")
struct TVEpisodeEntityMapperTests {

    let mapper = TVEpisodeEntityMapper()

    // MARK: - map(entity) → TVEpisode

    @Test("map entity to domain maps all properties")
    func mapEntityToDomain_mapsAllProperties() {
        let entity = TVEpisodeEntity.makeEntity()

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
        let entity = TVEpisodeEntity.makeEntity(
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

    // MARK: - map(TVEpisode) → entity

    @Test("map domain to entity maps all properties")
    func mapDomainToEntity_mapsAllProperties() {
        let episode = TVEpisode.mock()

        let result = mapper.map(episode)

        #expect(result.episodeID == episode.id)
        #expect(result.name == episode.name)
        #expect(result.episodeNumber == episode.episodeNumber)
        #expect(result.seasonNumber == episode.seasonNumber)
        #expect(result.overview == episode.overview)
        #expect(result.airDate == episode.airDate)
        #expect(result.runtime == episode.runtime)
        #expect(result.stillPath == episode.stillPath)
    }

    // MARK: - map(TVEpisode, to: entity)

    @Test("map domain to existing entity updates all properties")
    func mapDomainToExistingEntity_updatesAllProperties() {
        let entity = TVEpisodeEntity.makeEntity()
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

}

extension TVEpisodeEntity {

    static func makeEntity(
        episodeID: Int = 62085,
        name: String = "Pilot",
        episodeNumber: Int = 1,
        seasonNumber: Int = 1,
        overview: String? = "A chemistry teacher begins cooking meth.",
        airDate: Date? = Date(timeIntervalSince1970: 1_200_000_000),
        runtime: Int? = 58,
        stillPath: URL? = URL(string: "/still.jpg")
    ) -> TVEpisodeEntity {
        TVEpisodeEntity(
            episodeID: episodeID,
            name: name,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            runtime: runtime,
            stillPath: stillPath
        )
    }

}
