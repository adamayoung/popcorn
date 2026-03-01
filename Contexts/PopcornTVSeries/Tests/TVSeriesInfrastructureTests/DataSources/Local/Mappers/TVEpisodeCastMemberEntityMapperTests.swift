//
//  TVEpisodeCastMemberEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("TVEpisodeCastMemberEntityMapper")
struct TVEpisodeCastMemberEntityMapperTests {

    let mapper = TVEpisodeCastMemberEntityMapper()

    // MARK: - map(entity) -> CastMember

    @Test("map entity to domain maps all properties")
    func mapEntityToDomain_mapsAllProperties() {
        let entity = TVEpisodeCastMemberEntity.makeEpisodeEntity()

        let result = mapper.map(entity)

        #expect(result.id == entity.creditID)
        #expect(result.personID == entity.personID)
        #expect(result.characterName == entity.characterName)
        #expect(result.personName == entity.personName)
        #expect(result.profilePath == entity.profilePath)
        #expect(result.gender == .male)
        #expect(result.order == entity.order)
        #expect(result.initials == "BC")
    }

    @Test("map entity to domain with nil profile path")
    func mapEntityToDomain_withNilProfilePath() {
        let entity = TVEpisodeCastMemberEntity.makeEpisodeEntity(profilePath: nil)

        let result = mapper.map(entity)

        #expect(result.profilePath == nil)
    }

    @Test("map entity to domain maps female gender")
    func mapEntityToDomain_mapsFemaleGender() {
        let entity = TVEpisodeCastMemberEntity.makeEpisodeEntity(gender: 1)

        let result = mapper.map(entity)

        #expect(result.gender == .female)
    }

    // MARK: - map(CastMember, tvSeriesID:, seasonNumber:, episodeNumber:) -> Entity

    @Test("map domain to entity maps all properties")
    func mapDomainToEntity_mapsAllProperties() {
        let castMember = CastMember.mock()
        let tvSeriesID = 1396
        let seasonNumber = 1
        let episodeNumber = 1

        let result = mapper.map(
            castMember,
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber
        )

        #expect(result.creditID == castMember.id)
        #expect(result.tvSeriesID == tvSeriesID)
        #expect(result.seasonNumber == seasonNumber)
        #expect(result.episodeNumber == episodeNumber)
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

        let result = mapper.map(castMember, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)

        #expect(result.profilePath == nil)
    }

    // MARK: - Round-trip

    @Test("cast member survives domain to entity to domain round-trip")
    func castMemberSurvivesRoundTrip() {
        let castMember = CastMember.mock()

        let entity = mapper.map(castMember, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)
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

extension TVEpisodeCastMemberEntity {

    static func makeEpisodeEntity(
        creditID: String = "cast-credit-1",
        tvSeriesID: Int = 1396,
        seasonNumber: Int = 1,
        episodeNumber: Int = 1,
        personID: Int = 17419,
        characterName: String = "Walter White",
        personName: String = "Bryan Cranston",
        profilePath: URL? = URL(string: "/profile.jpg"),
        gender: Int = 2,
        order: Int = 0
    ) -> TVEpisodeCastMemberEntity {
        TVEpisodeCastMemberEntity(
            creditID: creditID,
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            personID: personID,
            characterName: characterName,
            personName: personName,
            profilePath: profilePath,
            gender: gender,
            order: order
        )
    }

}
