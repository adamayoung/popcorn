//
//  CastMemberEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("CastMemberEntityMapper")
struct CastMemberEntityMapperTests {

    let mapper = CastMemberEntityMapper()

    // MARK: - map(entity) -> CastMember

    @Test("map entity to domain maps all properties")
    func mapEntityToDomain_mapsAllProperties() {
        let entity = TVSeriesCastMemberEntity.makeEntity()

        let result = mapper.map(entity)

        #expect(result.id == entity.creditID)
        #expect(result.personID == entity.personID)
        #expect(result.characterName == entity.characterName)
        #expect(result.personName == entity.personName)
        #expect(result.profilePath == entity.profilePath)
        #expect(result.gender == .male)
        #expect(result.order == entity.order)
    }

    @Test("map entity to domain with nil profile path")
    func mapEntityToDomain_withNilProfilePath() {
        let entity = TVSeriesCastMemberEntity.makeEntity(profilePath: nil)

        let result = mapper.map(entity)

        #expect(result.profilePath == nil)
    }

    @Test("map entity to domain maps female gender")
    func mapEntityToDomain_mapsFemaleGender() {
        let entity = TVSeriesCastMemberEntity.makeEntity(gender: 1)

        let result = mapper.map(entity)

        #expect(result.gender == .female)
    }

    // MARK: - map(CastMember, tvSeriesID:) -> TVSeriesCastMemberEntity

    @Test("map domain to entity maps all properties")
    func mapDomainToEntity_mapsAllProperties() {
        let castMember = CastMember.mock()
        let tvSeriesID = 1396

        let result = mapper.map(castMember, tvSeriesID: tvSeriesID)

        #expect(result.creditID == castMember.id)
        #expect(result.tvSeriesID == tvSeriesID)
        #expect(result.personID == castMember.personID)
        #expect(result.characterName == castMember.characterName)
        #expect(result.personName == castMember.personName)
        #expect(result.profilePath == castMember.profilePath)
        #expect(result.gender == 2)
        #expect(result.order == castMember.order)
    }

    @Test("map domain to entity with nil profile path")
    func mapDomainToEntity_withNilProfilePath() {
        let castMember = CastMember.mock(profilePath: nil)

        let result = mapper.map(castMember, tvSeriesID: 1396)

        #expect(result.profilePath == nil)
    }

    // MARK: - map(CastMember, tvSeriesID:, to: entity)

    @Test("map domain to existing entity updates all properties")
    func mapDomainToExistingEntity_updatesAllProperties() {
        let entity = TVSeriesCastMemberEntity.makeEntity()
        let updatedCastMember = CastMember(
            id: entity.creditID,
            personID: 999,
            characterName: "Updated Character",
            personName: "Updated Person",
            profilePath: URL(string: "/updated-profile.jpg"),
            gender: .female,
            order: 5
        )

        mapper.map(updatedCastMember, tvSeriesID: 2000, to: entity)

        #expect(entity.tvSeriesID == 2000)
        #expect(entity.personID == 999)
        #expect(entity.characterName == "Updated Character")
        #expect(entity.personName == "Updated Person")
        #expect(entity.profilePath == URL(string: "/updated-profile.jpg"))
        #expect(entity.gender == 1)
        #expect(entity.order == 5)
    }

    // MARK: - Round-trip

    @Test("cast member survives domain to entity to domain round-trip")
    func castMemberSurvivesRoundTrip() {
        let castMember = CastMember.mock()
        let tvSeriesID = 1396

        let entity = mapper.map(castMember, tvSeriesID: tvSeriesID)
        let result = mapper.map(entity)

        #expect(result.id == castMember.id)
        #expect(result.personID == castMember.personID)
        #expect(result.characterName == castMember.characterName)
        #expect(result.personName == castMember.personName)
        #expect(result.profilePath == castMember.profilePath)
        #expect(result.gender == castMember.gender)
        #expect(result.order == castMember.order)
    }

}

extension TVSeriesCastMemberEntity {

    static func makeEntity(
        creditID: String = "cast-credit-1",
        tvSeriesID: Int = 1396,
        personID: Int = 17419,
        characterName: String = "Walter White",
        personName: String = "Bryan Cranston",
        profilePath: URL? = URL(string: "/profile.jpg"),
        gender: Int = 2,
        order: Int = 0
    ) -> TVSeriesCastMemberEntity {
        TVSeriesCastMemberEntity(
            creditID: creditID,
            tvSeriesID: tvSeriesID,
            personID: personID,
            characterName: characterName,
            personName: personName,
            profilePath: profilePath,
            gender: gender,
            order: order
        )
    }

}

extension CastMember {

    static func mock(
        id: String = "cast-credit-1",
        personID: Int = 17419,
        characterName: String = "Walter White",
        personName: String = "Bryan Cranston",
        profilePath: URL? = URL(string: "/profile.jpg"),
        gender: Gender = .male,
        order: Int = 0
    ) -> CastMember {
        CastMember(
            id: id,
            personID: personID,
            characterName: characterName,
            personName: personName,
            profilePath: profilePath,
            gender: gender,
            order: order
        )
    }

}
