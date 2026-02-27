//
//  CrewMemberEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("CrewMemberEntityMapper")
struct CrewMemberEntityMapperTests {

    let mapper = CrewMemberEntityMapper()

    // MARK: - map(entity) -> CrewMember

    @Test("map entity to domain maps all properties")
    func mapEntityToDomain_mapsAllProperties() {
        let entity = TVSeriesCrewMemberEntity.makeEntity()

        let result = mapper.map(entity)

        #expect(result.id == entity.creditID)
        #expect(result.personID == entity.personID)
        #expect(result.personName == entity.personName)
        #expect(result.job == entity.job)
        #expect(result.profilePath == entity.profilePath)
        #expect(result.gender == .male)
        #expect(result.department == entity.department)
    }

    @Test("map entity to domain with nil profile path")
    func mapEntityToDomain_withNilProfilePath() {
        let entity = TVSeriesCrewMemberEntity.makeEntity(profilePath: nil)

        let result = mapper.map(entity)

        #expect(result.profilePath == nil)
    }

    @Test("map entity to domain maps female gender")
    func mapEntityToDomain_mapsFemaleGender() {
        let entity = TVSeriesCrewMemberEntity.makeEntity(gender: 1)

        let result = mapper.map(entity)

        #expect(result.gender == .female)
    }

    // MARK: - map(CrewMember, tvSeriesID:) -> TVSeriesCrewMemberEntity

    @Test("map domain to entity maps all properties")
    func mapDomainToEntity_mapsAllProperties() {
        let crewMember = CrewMember.mock()
        let tvSeriesID = 1396

        let result = mapper.map(crewMember, tvSeriesID: tvSeriesID)

        #expect(result.creditID == crewMember.id)
        #expect(result.tvSeriesID == tvSeriesID)
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

        let result = mapper.map(crewMember, tvSeriesID: 1396)

        #expect(result.profilePath == nil)
    }

    // MARK: - map(CrewMember, tvSeriesID:, to: entity)

    @Test("map domain to existing entity updates all properties")
    func mapDomainToExistingEntity_updatesAllProperties() {
        let entity = TVSeriesCrewMemberEntity.makeEntity()
        let updatedCrewMember = CrewMember(
            id: entity.creditID,
            personID: 888,
            personName: "Updated Person",
            job: "Producer",
            profilePath: URL(string: "/updated-profile.jpg"),
            gender: .female,
            department: "Production"
        )

        mapper.map(updatedCrewMember, tvSeriesID: 2000, to: entity)

        #expect(entity.tvSeriesID == 2000)
        #expect(entity.personID == 888)
        #expect(entity.personName == "Updated Person")
        #expect(entity.job == "Producer")
        #expect(entity.profilePath == URL(string: "/updated-profile.jpg"))
        #expect(entity.gender == 1)
        #expect(entity.department == "Production")
    }

    // MARK: - Round-trip

    @Test("crew member survives domain to entity to domain round-trip")
    func crewMemberSurvivesRoundTrip() {
        let crewMember = CrewMember.mock()
        let tvSeriesID = 1396

        let entity = mapper.map(crewMember, tvSeriesID: tvSeriesID)
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

extension TVSeriesCrewMemberEntity {

    static func makeEntity(
        creditID: String = "crew-credit-1",
        tvSeriesID: Int = 1396,
        personID: Int = 66633,
        personName: String = "Vince Gilligan",
        job: String = "Director",
        profilePath: URL? = URL(string: "/crew-profile.jpg"),
        gender: Int = 2,
        department: String = "Directing"
    ) -> TVSeriesCrewMemberEntity {
        TVSeriesCrewMemberEntity(
            creditID: creditID,
            tvSeriesID: tvSeriesID,
            personID: personID,
            personName: personName,
            job: job,
            profilePath: profilePath,
            gender: gender,
            department: department
        )
    }

}

extension CrewMember {

    static func mock(
        id: String = "crew-credit-1",
        personID: Int = 66633,
        personName: String = "Vince Gilligan",
        job: String = "Director",
        profilePath: URL? = URL(string: "/crew-profile.jpg"),
        gender: Gender = .male,
        department: String = "Directing"
    ) -> CrewMember {
        CrewMember(
            id: id,
            personID: personID,
            personName: personName,
            job: job,
            profilePath: profilePath,
            gender: gender,
            department: department
        )
    }

}
