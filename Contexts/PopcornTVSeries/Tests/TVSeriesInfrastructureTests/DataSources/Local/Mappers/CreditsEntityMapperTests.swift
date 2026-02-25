//
//  CreditsEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("CreditsEntityMapper")
struct CreditsEntityMapperTests {

    let mapper = CreditsEntityMapper()

    // MARK: - map(entity) -> Credits

    @Test("map entity to domain maps tvSeriesID to id")
    func mapEntityToDomain_mapsTVSeriesIDToID() {
        let entity = TVSeriesCreditsEntity.makeEntity(tvSeriesID: 1396)

        let result = mapper.map(entity)

        #expect(result.id == 1396)
    }

    @Test("map entity to domain maps cast members")
    func mapEntityToDomain_mapsCastMembers() {
        let castEntity = TVSeriesCastMemberEntity.makeEntity(
            creditID: "cast-1",
            personName: "Bryan Cranston",
            order: 0
        )
        let entity = TVSeriesCreditsEntity.makeEntity(cast: [castEntity])

        let result = mapper.map(entity)

        #expect(result.cast.count == 1)
        #expect(result.cast[0].id == "cast-1")
        #expect(result.cast[0].personName == "Bryan Cranston")
    }

    @Test("map entity to domain maps crew members")
    func mapEntityToDomain_mapsCrewMembers() {
        let crewEntity = TVSeriesCrewMemberEntity.makeEntity(
            creditID: "crew-1",
            personName: "Vince Gilligan"
        )
        let entity = TVSeriesCreditsEntity.makeEntity(crew: [crewEntity])

        let result = mapper.map(entity)

        #expect(result.crew.count == 1)
        #expect(result.crew[0].id == "crew-1")
        #expect(result.crew[0].personName == "Vince Gilligan")
    }

    @Test("map entity to domain sorts cast by order")
    func mapEntityToDomain_sortsCastByOrder() {
        let cast1 = TVSeriesCastMemberEntity.makeEntity(
            creditID: "cast-2",
            personName: "Aaron Paul",
            order: 1
        )
        let cast2 = TVSeriesCastMemberEntity.makeEntity(
            creditID: "cast-1",
            personName: "Bryan Cranston",
            order: 0
        )
        let entity = TVSeriesCreditsEntity.makeEntity(cast: [cast1, cast2])

        let result = mapper.map(entity)

        #expect(result.cast[0].personName == "Bryan Cranston")
        #expect(result.cast[1].personName == "Aaron Paul")
    }

    @Test("map entity to domain with empty cast and crew")
    func mapEntityToDomain_withEmptyCastAndCrew() {
        let entity = TVSeriesCreditsEntity.makeEntity()

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
        let entity = TVSeriesCreditsEntity.makeEntity(tvSeriesID: 1396)

        let result = mapper.compactMap(entity)

        #expect(result != nil)
        #expect(result?.id == 1396)
    }

    // MARK: - map(Credits, tvSeriesID:) -> TVSeriesCreditsEntity

    @Test("map domain to entity maps tvSeriesID")
    func mapDomainToEntity_mapsTVSeriesID() {
        let credits = Credits.mock()

        let result = mapper.map(credits, tvSeriesID: 1396)

        #expect(result.tvSeriesID == 1396)
    }

    @Test("map domain to entity maps cast members")
    func mapDomainToEntity_mapsCastMembers() {
        let castMember = CastMember.mock(id: "cast-1", personName: "Bryan Cranston")
        let credits = Credits.mock(cast: [castMember])

        let result = mapper.map(credits, tvSeriesID: 1396)

        #expect(result.cast.count == 1)
        #expect(result.cast[0].creditID == "cast-1")
        #expect(result.cast[0].tvSeriesID == 1396)
    }

    @Test("map domain to entity maps crew members")
    func mapDomainToEntity_mapsCrewMembers() {
        let crewMember = CrewMember.mock(id: "crew-1", personName: "Vince Gilligan")
        let credits = Credits.mock(crew: [crewMember])

        let result = mapper.map(credits, tvSeriesID: 1396)

        #expect(result.crew.count == 1)
        #expect(result.crew[0].creditID == "crew-1")
        #expect(result.crew[0].tvSeriesID == 1396)
    }

    // MARK: - map(Credits, tvSeriesID:, to: entity)

    @Test("map domain to existing entity updates cast and crew")
    func mapDomainToExistingEntity_updatesCastAndCrew() {
        let entity = TVSeriesCreditsEntity.makeEntity()
        let castMember = CastMember.mock(id: "cast-new")
        let crewMember = CrewMember.mock(id: "crew-new")
        let credits = Credits.mock(cast: [castMember], crew: [crewMember])

        mapper.map(credits, tvSeriesID: 1396, to: entity)

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
        let tvSeriesID = 1396

        let entity = mapper.map(credits, tvSeriesID: tvSeriesID)
        let result = mapper.map(entity)

        #expect(result.id == tvSeriesID)
        #expect(result.cast.count == 1)
        #expect(result.cast[0].id == "cast-1")
        #expect(result.crew.count == 1)
        #expect(result.crew[0].id == "crew-1")
    }

}

extension TVSeriesCreditsEntity {

    static func makeEntity(
        tvSeriesID: Int = 1396,
        cast: [TVSeriesCastMemberEntity] = [],
        crew: [TVSeriesCrewMemberEntity] = [],
        cachedAt: Date = Date.now
    ) -> TVSeriesCreditsEntity {
        TVSeriesCreditsEntity(
            tvSeriesID: tvSeriesID,
            cast: cast,
            crew: crew,
            cachedAt: cachedAt
        )
    }

}

extension Credits {

    static func mock(
        id: Int = 1396,
        cast: [CastMember] = [],
        crew: [CrewMember] = []
    ) -> Credits {
        Credits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
