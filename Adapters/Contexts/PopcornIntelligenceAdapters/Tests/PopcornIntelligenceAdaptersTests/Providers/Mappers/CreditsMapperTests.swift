//
//  CreditsMapperTests.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
import MoviesApplication
@testable import PopcornIntelligenceAdapters
import Testing

@Suite("CreditsMapper Tests")
struct CreditsMapperTests {

    private let mapper = CreditsMapper()

    @Test("Maps all properties from CreditsDetails to IntelligenceDomain Credits")
    func mapsAllProperties() throws {
        let castProfileURLSet = try makeImageURLSet(path: "cast_profile.jpg")
        let crewProfileURLSet = try makeImageURLSet(path: "crew_profile.jpg")

        let castMember = CastMemberDetails(
            id: "cast-123",
            personID: 456,
            characterName: "Tyler Durden",
            personName: "Brad Pitt",
            profileURLSet: castProfileURLSet,
            gender: .male,
            order: 0
        )

        let crewMember = CrewMemberDetails(
            id: "crew-789",
            personID: 101,
            personName: "David Fincher",
            job: "Director",
            profileURLSet: crewProfileURLSet,
            gender: .male,
            department: "Directing"
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [castMember],
            crew: [crewMember]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 550)
        #expect(result.cast.count == 1)
        #expect(result.crew.count == 1)

        let mappedCast = try #require(result.cast.first)
        #expect(mappedCast.id == "cast-123")
        #expect(mappedCast.personID == 456)
        #expect(mappedCast.characterName == "Tyler Durden")
        #expect(mappedCast.personName == "Brad Pitt")
        #expect(mappedCast.profilePath == castProfileURLSet.path)
        #expect(mappedCast.gender == .male)
        #expect(mappedCast.order == 0)

        let mappedCrew = try #require(result.crew.first)
        #expect(mappedCrew.id == "crew-789")
        #expect(mappedCrew.personID == 101)
        #expect(mappedCrew.personName == "David Fincher")
        #expect(mappedCrew.job == "Director")
        #expect(mappedCrew.profilePath == crewProfileURLSet.path)
        #expect(mappedCrew.gender == .male)
        #expect(mappedCrew.department == "Directing")
    }

    @Test("Maps with empty cast and crew arrays")
    func mapsWithEmptyCastAndCrewArrays() {
        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 550)
        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    @Test("Maps cast member with nil profile URL")
    func mapsCastMemberWithNilProfileURL() {
        let castMember = CastMemberDetails(
            id: "cast-123",
            personID: 456,
            characterName: "Tyler Durden",
            personName: "Brad Pitt",
            profileURLSet: nil,
            gender: .male,
            order: 0
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [castMember],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        let mappedCast = result.cast.first
        #expect(mappedCast?.profilePath == nil)
    }

    @Test("Maps crew member with nil profile URL")
    func mapsCrewMemberWithNilProfileURL() {
        let crewMember = CrewMemberDetails(
            id: "crew-789",
            personID: 101,
            personName: "David Fincher",
            job: "Director",
            profileURLSet: nil,
            gender: .male,
            department: "Directing"
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [],
            crew: [crewMember]
        )

        let result = mapper.map(creditsDetails)

        let mappedCrew = result.crew.first
        #expect(mappedCrew?.profilePath == nil)
    }

    @Test("Maps multiple cast members preserving order")
    func mapsMultipleCastMembersPreservingOrder() {
        let castMember1 = CastMemberDetails(
            id: "cast-1",
            personID: 1,
            characterName: "Character 1",
            personName: "Actor 1",
            gender: .male,
            order: 0
        )

        let castMember2 = CastMemberDetails(
            id: "cast-2",
            personID: 2,
            characterName: "Character 2",
            personName: "Actor 2",
            gender: .female,
            order: 1
        )

        let castMember3 = CastMemberDetails(
            id: "cast-3",
            personID: 3,
            characterName: "Character 3",
            personName: "Actor 3",
            gender: .other,
            order: 2
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [castMember1, castMember2, castMember3],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.cast.count == 3)
        #expect(result.cast[0].id == "cast-1")
        #expect(result.cast[1].id == "cast-2")
        #expect(result.cast[2].id == "cast-3")
    }

    @Test("Maps multiple crew members preserving order")
    func mapsMultipleCrewMembersPreservingOrder() {
        let crewMember1 = CrewMemberDetails(
            id: "crew-1",
            personID: 1,
            personName: "Crew 1",
            job: "Director",
            gender: .male,
            department: "Directing"
        )

        let crewMember2 = CrewMemberDetails(
            id: "crew-2",
            personID: 2,
            personName: "Crew 2",
            job: "Producer",
            gender: .female,
            department: "Production"
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [],
            crew: [crewMember1, crewMember2]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.crew.count == 2)
        #expect(result.crew[0].id == "crew-1")
        #expect(result.crew[1].id == "crew-2")
    }

    @Test("Maps all gender types correctly")
    func mapsAllGenderTypesCorrectly() {
        let unknownGenderCast = CastMemberDetails(
            id: "cast-1",
            personID: 1,
            characterName: "Character",
            personName: "Actor",
            gender: .unknown,
            order: 0
        )

        let femaleCast = CastMemberDetails(
            id: "cast-2",
            personID: 2,
            characterName: "Character",
            personName: "Actor",
            gender: .female,
            order: 1
        )

        let maleCast = CastMemberDetails(
            id: "cast-3",
            personID: 3,
            characterName: "Character",
            personName: "Actor",
            gender: .male,
            order: 2
        )

        let otherGenderCast = CastMemberDetails(
            id: "cast-4",
            personID: 4,
            characterName: "Character",
            personName: "Actor",
            gender: .other,
            order: 3
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [unknownGenderCast, femaleCast, maleCast, otherGenderCast],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.cast[0].gender == .unknown)
        #expect(result.cast[1].gender == .female)
        #expect(result.cast[2].gender == .male)
        #expect(result.cast[3].gender == .other)
    }

}

// MARK: - Test Helpers

extension CreditsMapperTests {

    private func makeImageURLSet(path: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/\(path)")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w342/\(path)")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/w500/\(path)")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)"))
        )
    }

}
