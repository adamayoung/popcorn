//
//  TVEpisodeCreditsEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("TVEpisodeCreditsEntityMapper")
struct TVEpisodeCreditsEntityMapperTests {

    let mapper = TVEpisodeCreditsEntityMapper()

    // MARK: - map(entity) -> Credits

    @Test("map entity to domain maps tvSeriesID to id")
    func mapEntityToDomain_mapsTVSeriesIDToID() {
        let entity = TVEpisodeCreditsEntity.makeEpisodeEntity(tvSeriesID: 1396)

        let result = mapper.map(entity)

        #expect(result.id == 1396)
    }

    @Test("map entity to domain maps cast members")
    func mapEntityToDomain_mapsCastMembers() {
        let castEntity = TVEpisodeCastMemberEntity.makeEpisodeEntity(
            creditID: "cast-1",
            personName: "Bryan Cranston",
            order: 0
        )
        let entity = TVEpisodeCreditsEntity.makeEpisodeEntity(cast: [castEntity])

        let result = mapper.map(entity)

        #expect(result.cast.count == 1)
        #expect(result.cast[0].id == "cast-1")
        #expect(result.cast[0].personName == "Bryan Cranston")
    }

    @Test("map entity to domain maps crew members")
    func mapEntityToDomain_mapsCrewMembers() {
        let crewEntity = TVEpisodeCrewMemberEntity.makeEpisodeEntity(
            creditID: "crew-1",
            personName: "Vince Gilligan"
        )
        let entity = TVEpisodeCreditsEntity.makeEpisodeEntity(crew: [crewEntity])

        let result = mapper.map(entity)

        #expect(result.crew.count == 1)
        #expect(result.crew[0].id == "crew-1")
        #expect(result.crew[0].personName == "Vince Gilligan")
    }

    @Test("map entity to domain sorts cast by order")
    func mapEntityToDomain_sortsCastByOrder() {
        let cast1 = TVEpisodeCastMemberEntity.makeEpisodeEntity(
            creditID: "cast-2",
            personName: "Aaron Paul",
            order: 1
        )
        let cast2 = TVEpisodeCastMemberEntity.makeEpisodeEntity(
            creditID: "cast-1",
            personName: "Bryan Cranston",
            order: 0
        )
        let entity = TVEpisodeCreditsEntity.makeEpisodeEntity(cast: [cast1, cast2])

        let result = mapper.map(entity)

        #expect(result.cast[0].personName == "Bryan Cranston")
        #expect(result.cast[1].personName == "Aaron Paul")
    }

    @Test("map entity to domain with empty cast and crew")
    func mapEntityToDomain_withEmptyCastAndCrew() {
        let entity = TVEpisodeCreditsEntity.makeEpisodeEntity()

        let result = mapper.map(entity)

        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    // MARK: - compactMap

    @Test("compactMap returns nil for nil entity")
    func compactMap_returnsNilForNilEntity() {
        let result = mapper.compactMap(nil)

        #expect(result == nil)
    }

    @Test("compactMap returns credits for non-nil entity")
    func compactMap_returnsCreditsForNonNilEntity() {
        let entity = TVEpisodeCreditsEntity.makeEpisodeEntity(tvSeriesID: 1396)

        let result = mapper.compactMap(entity)

        #expect(result != nil)
        #expect(result?.id == 1396)
    }

    // MARK: - map(Credits, tvSeriesID:, seasonNumber:, episodeNumber:) -> Entity

    @Test("map domain to entity maps tvSeriesID, seasonNumber, episodeNumber")
    func mapDomainToEntity_mapsIdentifiers() {
        let credits = Credits.mock()

        let result = mapper.map(credits, tvSeriesID: 1396, seasonNumber: 2, episodeNumber: 3)

        #expect(result.tvSeriesID == 1396)
        #expect(result.seasonNumber == 2)
        #expect(result.episodeNumber == 3)
    }

    @Test("map domain to entity maps cast members")
    func mapDomainToEntity_mapsCastMembers() {
        let castMember = CastMember.mock(id: "cast-1", personName: "Bryan Cranston")
        let credits = Credits.mock(cast: [castMember])

        let result = mapper.map(credits, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)

        #expect(result.cast.count == 1)
        #expect(result.cast[0].creditID == "cast-1")
        #expect(result.cast[0].tvSeriesID == 1396)
        #expect(result.cast[0].seasonNumber == 1)
        #expect(result.cast[0].episodeNumber == 1)
    }

    @Test("map domain to entity maps crew members")
    func mapDomainToEntity_mapsCrewMembers() {
        let crewMember = CrewMember.mock(id: "crew-1", personName: "Vince Gilligan")
        let credits = Credits.mock(crew: [crewMember])

        let result = mapper.map(credits, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)

        #expect(result.crew.count == 1)
        #expect(result.crew[0].creditID == "crew-1")
        #expect(result.crew[0].tvSeriesID == 1396)
        #expect(result.crew[0].seasonNumber == 1)
        #expect(result.crew[0].episodeNumber == 1)
    }

    // MARK: - map(Credits, to: entity)

    @Test("map domain to existing entity updates cast and crew")
    func mapDomainToExistingEntity_updatesCastAndCrew() {
        let entity = TVEpisodeCreditsEntity.makeEpisodeEntity()
        let castMember = CastMember.mock(id: "cast-new")
        let crewMember = CrewMember.mock(id: "crew-new")
        let credits = Credits.mock(cast: [castMember], crew: [crewMember])

        mapper.map(credits, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1, to: entity)

        #expect(entity.cast.count == 1)
        #expect(entity.cast[0].creditID == "cast-new")
        #expect(entity.crew.count == 1)
        #expect(entity.crew[0].creditID == "crew-new")
    }

    // MARK: - Round-trip

    @Test("credits survive domain to entity to domain round-trip")
    func creditsSurviveRoundTrip() {
        let castMember = CastMember.mock(id: "cast-1", order: 0)
        let crewMember = CrewMember.mock(id: "crew-1")
        let credits = Credits.mock(cast: [castMember], crew: [crewMember])

        let entity = mapper.map(credits, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)
        let result = mapper.map(entity)

        #expect(result.id == 1396)
        #expect(result.cast.count == 1)
        #expect(result.cast[0].id == "cast-1")
        #expect(result.crew.count == 1)
        #expect(result.crew[0].id == "crew-1")
    }

}

extension TVEpisodeCreditsEntity {

    static func makeEpisodeEntity(
        tvSeriesID: Int = 1396,
        seasonNumber: Int = 1,
        episodeNumber: Int = 1,
        cast: [TVEpisodeCastMemberEntity] = [],
        crew: [TVEpisodeCrewMemberEntity] = [],
        cachedAt: Date = Date.now
    ) -> TVEpisodeCreditsEntity {
        TVEpisodeCreditsEntity(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            cast: cast,
            crew: crew,
            cachedAt: cachedAt
        )
    }

}
