//
//  CreditsMapperTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
@testable import MovieCastAndCrewFeature
import MoviesApplication
import Testing

@Suite("CreditsMapper Tests")
struct CreditsMapperTests {

    private let mapper = CreditsMapper()

    @Test("Maps CreditsDetails to Credits with all properties")
    func mapsCreditsDetailsWithAllProperties() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let castMemberDetails = CastMemberDetails(
            id: "cast-1",
            personID: 83271,
            characterName: "Ben Richards",
            personName: "Glen Powell",
            profileURLSet: profileURLSet,
            gender: .male,
            order: 0
        )

        let crewMemberDetails = CrewMemberDetails(
            id: "crew-1",
            personID: 12345,
            personName: "Christopher Nolan",
            job: "Director",
            profileURLSet: profileURLSet,
            gender: .male,
            department: "Directing"
        )

        let creditsDetails = CreditsDetails(
            id: 798_645,
            cast: [castMemberDetails],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 798_645)
        #expect(result.castMembers.count == 1)
        #expect(result.crewMembers.count == 1)

        let castMember = result.castMembers[0]
        #expect(castMember.id == "cast-1")
        #expect(castMember.personID == 83271)
        #expect(castMember.characterName == "Ben Richards")
        #expect(castMember.personName == "Glen Powell")
        #expect(castMember.profileURL == URL(string: "https://example.com/detail.jpg"))

        let crewMember = result.crewMembers[0]
        #expect(crewMember.id == "crew-1")
        #expect(crewMember.personID == 12345)
        #expect(crewMember.personName == "Christopher Nolan")
        #expect(crewMember.job == "Director")
        #expect(crewMember.profileURL == URL(string: "https://example.com/detail.jpg"))
        #expect(crewMember.department == "Directing")
    }

    @Test("Maps all cast members without limit")
    func mapsAllCastMembersWithoutLimit() {
        let castMembers = (1 ... 10).map { index in
            CastMemberDetails(
                id: "cast-\(index)",
                personID: index,
                characterName: "Character \(index)",
                personName: "Actor \(index)",
                gender: .unknown,
                order: index - 1
            )
        }

        let creditsDetails = CreditsDetails(
            id: 123,
            cast: castMembers,
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers.count == 10)
    }

    @Test("Maps all crew members without limit")
    func mapsAllCrewMembersWithoutLimit() {
        let crewMembers = (1 ... 10).map { index in
            CrewMemberDetails(
                id: "crew-\(index)",
                personID: index,
                personName: "Person \(index)",
                job: "Job \(index)",
                gender: .unknown,
                department: "Department \(index)"
            )
        }

        let creditsDetails = CreditsDetails(
            id: 123,
            cast: [],
            crew: crewMembers
        )

        let result = mapper.map(creditsDetails)

        #expect(result.crewMembers.count == 10)
    }

    @Test("Maps with empty cast and crew arrays")
    func mapsWithEmptyArrays() {
        let creditsDetails = CreditsDetails(
            id: 789,
            cast: [],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 789)
        #expect(result.castMembers.isEmpty)
        #expect(result.crewMembers.isEmpty)
    }

    @Test("Maps with nil profile URL sets")
    func mapsWithNilProfileURLSets() {
        let castMemberDetails = CastMemberDetails(
            id: "cast-1",
            personID: 83271,
            characterName: "Ben Richards",
            personName: "Glen Powell",
            profileURLSet: nil,
            gender: .male,
            order: 0
        )

        let crewMemberDetails = CrewMemberDetails(
            id: "crew-1",
            personID: 12345,
            personName: "Christopher Nolan",
            job: "Director",
            profileURLSet: nil,
            gender: .male,
            department: "Directing"
        )

        let creditsDetails = CreditsDetails(
            id: 123,
            cast: [castMemberDetails],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers[0].profileURL == nil)
        #expect(result.crewMembers[0].profileURL == nil)
    }

}
