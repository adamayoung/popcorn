//
//  TVEpisodeCrewMemberEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("TVEpisodeCrewMemberEntityMapper")
struct TVEpisodeCrewMemberEntityMapperTests {

    let mapper = TVEpisodeCrewMemberEntityMapper()

    // MARK: - map(entity) -> CrewMember

    @Test("map entity to domain maps all properties")
    func mapEntityToDomain_mapsAllProperties() {
        let entity = TVEpisodeCrewMemberEntity.makeEpisodeEntity()

        let result = mapper.map(entity)

        #expect(result.id == entity.creditID)
        #expect(result.personID == entity.personID)
        #expect(result.personName == entity.personName)
        #expect(result.job == entity.job)
        #expect(result.profilePath == entity.profilePath)
        #expect(result.gender == .male)
        #expect(result.department == entity.department)
        #expect(result.initials == "VG")
    }

    @Test("map entity to domain with nil profile path")
    func mapEntityToDomain_withNilProfilePath() {
        let entity = TVEpisodeCrewMemberEntity.makeEpisodeEntity(profilePath: nil)

        let result = mapper.map(entity)

        #expect(result.profilePath == nil)
    }

    @Test("map entity to domain maps female gender")
    func mapEntityToDomain_mapsFemaleGender() {
        let entity = TVEpisodeCrewMemberEntity.makeEpisodeEntity(gender: 1)

        let result = mapper.map(entity)

        #expect(result.gender == .female)
    }

    // MARK: - map(CrewMember, tvSeriesID:, seasonNumber:, episodeNumber:) -> Entity

    @Test("map domain to entity maps all properties")
    func mapDomainToEntity_mapsAllProperties() {
        let crewMember = CrewMember.mock()
        let tvSeriesID = 1396
        let seasonNumber = 1
        let episodeNumber = 1

        let result = mapper.map(
            crewMember,
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber
        )

        #expect(result.creditID == crewMember.id)
        #expect(result.tvSeriesID == tvSeriesID)
        #expect(result.seasonNumber == seasonNumber)
        #expect(result.episodeNumber == episodeNumber)
        #expect(result.personID == crewMember.personID)
        #expect(result.personName == crewMember.personName)
        #expect(result.job == crewMember.job)
        #expect(result.profilePath == crewMember.profilePath)
        #expect(result.gender == 2)
        #expect(result.department == crewMember.department)
    }

    @Test("map domain to entity with nil profile path")
    func mapDomainToEntity_withNilProfilePath() {
        let crewMember = CrewMember.mock(profilePath: nil)

        let result = mapper.map(crewMember, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)

        #expect(result.profilePath == nil)
    }

    // MARK: - Round-trip

    @Test("crew member survives domain to entity to domain round-trip")
    func crewMemberSurvivesRoundTrip() {
        let crewMember = CrewMember.mock()

        let entity = mapper.map(crewMember, tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)
        let result = mapper.map(entity)

        #expect(result.id == crewMember.id)
        #expect(result.personID == crewMember.personID)
        #expect(result.personName == crewMember.personName)
        #expect(result.job == crewMember.job)
        #expect(result.profilePath == crewMember.profilePath)
        #expect(result.gender == crewMember.gender)
        #expect(result.department == crewMember.department)
    }

}

extension TVEpisodeCrewMemberEntity {

    static func makeEpisodeEntity(
        creditID: String = "crew-credit-1",
        tvSeriesID: Int = 1396,
        seasonNumber: Int = 1,
        episodeNumber: Int = 1,
        personID: Int = 66633,
        personName: String = "Vince Gilligan",
        job: String = "Director",
        profilePath: URL? = URL(string: "/crew-profile.jpg"),
        gender: Int = 2,
        department: String = "Directing"
    ) -> TVEpisodeCrewMemberEntity {
        TVEpisodeCrewMemberEntity(
            creditID: creditID,
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            personID: personID,
            personName: personName,
            job: job,
            profilePath: profilePath,
            gender: gender,
            department: department
        )
    }

}
