//
//  CreditsMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
@testable import TVEpisodeCastAndCrewFeature
import TVSeriesApplication

@Suite("CreditsMapper Tests")
struct CreditsMapperTests {

    private let mapper = CreditsMapper()

    @Test("Maps cast member properties from CreditsDetails")
    func mapsCastMemberProperties() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let castMemberDetails = CastMemberDetails(
            id: "cast-1",
            personID: 17419,
            characterName: "Eleven",
            personName: "Millie Bobby Brown",
            profileURLSet: profileURLSet,
            gender: .female,
            order: 0,
            initials: "MB"
        )

        let creditsDetails = CreditsDetails(id: 1396, cast: [castMemberDetails], crew: [])
        let result = mapper.map(creditsDetails)

        #expect(result.id == 1396)
        #expect(result.castMembers.count == 1)

        let castMember = result.castMembers[0]
        #expect(castMember.id == "cast-1")
        #expect(castMember.personID == 17419)
        #expect(castMember.characterName == "Eleven")
        #expect(castMember.personName == "Millie Bobby Brown")
        #expect(castMember.profileURL == URL(string: "https://example.com/detail.jpg"))
        #expect(castMember.initials == "MB")
    }

    @Test("Maps crew member properties from CreditsDetails")
    func mapsCrewMemberProperties() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let crewMemberDetails = CrewMemberDetails(
            id: "crew-1",
            personID: 1_222_585,
            personName: "Matt Duffer",
            job: "Director",
            profileURLSet: profileURLSet,
            gender: .male,
            department: "Directing",
            initials: "MD"
        )

        let creditsDetails = CreditsDetails(id: 1396, cast: [], crew: [crewMemberDetails])
        let result = mapper.map(creditsDetails)

        #expect(result.crewMembers.count == 1)

        let crewMember = result.crewMembers[0]
        #expect(crewMember.id == "crew-1")
        #expect(crewMember.personID == 1_222_585)
        #expect(crewMember.personName == "Matt Duffer")
        #expect(crewMember.job == "Director")
        #expect(crewMember.department == "Directing")
        #expect(crewMember.profileURL == URL(string: "https://example.com/detail.jpg"))
        #expect(crewMember.initials == "MD")
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
            id: 1396,
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
            id: 1396,
            cast: [],
            crew: crewMembers
        )

        let result = mapper.map(creditsDetails)

        #expect(result.crewMembers.count == 10)
    }

    @Test("Maps with empty cast and crew arrays")
    func mapsWithEmptyArrays() {
        let creditsDetails = CreditsDetails(
            id: 1396,
            cast: [],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 1396)
        #expect(result.castMembers.isEmpty)
        #expect(result.crewMembers.isEmpty)
    }

    @Test("Maps with nil profile URL sets")
    func mapsWithNilProfileURLSets() {
        let castMemberDetails = CastMemberDetails(
            id: "cast-1",
            personID: 17419,
            characterName: "Eleven",
            personName: "Millie Bobby Brown",
            profileURLSet: nil,
            gender: .female,
            order: 0
        )

        let crewMemberDetails = CrewMemberDetails(
            id: "crew-1",
            personID: 1_222_585,
            personName: "Matt Duffer",
            job: "Director",
            profileURLSet: nil,
            gender: .male,
            department: "Directing"
        )

        let creditsDetails = CreditsDetails(
            id: 1396,
            cast: [castMemberDetails],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers[0].profileURL == nil)
        #expect(result.crewMembers[0].profileURL == nil)
    }

    @Test("Maps cast member with correct initials")
    func mapsCastMemberWithCorrectInitials() {
        let castMemberDetails = CastMemberDetails(
            id: "cast-1",
            personID: 17419,
            characterName: "Eleven",
            personName: "Millie Bobby Brown",
            gender: .female,
            order: 0,
            initials: "MB"
        )

        let creditsDetails = CreditsDetails(
            id: 1396,
            cast: [castMemberDetails],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers[0].initials == "MB")
    }

    @Test("Maps crew member with correct department")
    func mapsCrewMemberWithCorrectDepartment() {
        let crewMemberDetails = CrewMemberDetails(
            id: "crew-1",
            personID: 1_222_585,
            personName: "Matt Duffer",
            job: "Creator",
            gender: .male,
            department: "Production",
            initials: "MD"
        )

        let creditsDetails = CreditsDetails(
            id: 1396,
            cast: [],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        let crewMember = result.crewMembers[0]
        #expect(crewMember.department == "Production")
        #expect(crewMember.initials == "MD")
    }

}
