//
//  CreditsMapperTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesApplication
@testable import TVSeriesDetailsFeature

@Suite("CreditsMapper Tests")
struct CreditsMapperTests {

    private let mapper = CreditsMapper()

    @Test("Maps all properties from CreditsDetails to Credits")
    func mapsAllProperties() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/profile-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/profile-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/profile-card.jpg")),
            detail: #require(URL(string: "https://example.com/profile-detail.jpg")),
            full: #require(URL(string: "https://example.com/profile-full.jpg"))
        )

        let castMemberDetails = CastMemberDetails(
            id: "cast-1",
            personID: 17419,
            characterName: "Eleven",
            personName: "Millie Bobby Brown",
            profileURLSet: profileURLSet,
            gender: .female,
            order: 0
        )

        let crewMemberDetails = CrewMemberDetails(
            id: "crew-1",
            personID: 12345,
            personName: "The Duffer Brothers",
            job: "Creator",
            profileURLSet: profileURLSet,
            gender: .male,
            department: "Writing"
        )

        let creditsDetails = CreditsDetails(
            id: 66732,
            cast: [castMemberDetails],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 66732)
        #expect(result.castMembers.count == 1)
        #expect(result.crewMembers.count == 1)

        let castMember = result.castMembers[0]
        #expect(castMember.id == "cast-1")
        #expect(castMember.personID == 17419)
        #expect(castMember.characterName == "Eleven")
        #expect(castMember.personName == "Millie Bobby Brown")
        #expect(castMember.profileURL == URL(string: "https://example.com/profile-detail.jpg"))

        let crewMember = result.crewMembers[0]
        #expect(crewMember.id == "crew-1")
        #expect(crewMember.personID == 12345)
        #expect(crewMember.personName == "The Duffer Brothers")
        #expect(crewMember.job == "Creator")
        #expect(crewMember.profileURL == URL(string: "https://example.com/profile-detail.jpg"))
        #expect(crewMember.department == "Writing")
    }

    @Test("Limits cast members to first 5")
    func limitsCastMembersToFirst5() {
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

        #expect(result.castMembers.count == 5)
        #expect(result.castMembers[0].id == "cast-1")
        #expect(result.castMembers[4].id == "cast-5")
    }

    @Test("Limits crew members to first 5")
    func limitsCrewMembersToFirst5() {
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

        #expect(result.crewMembers.count == 5)
        #expect(result.crewMembers[0].id == "crew-1")
        #expect(result.crewMembers[4].id == "crew-5")
    }

    @Test("Handles fewer than 5 cast and crew members")
    func handlesFewerThan5Members() {
        let castMembers = (1 ... 3).map { index in
            CastMemberDetails(
                id: "cast-\(index)",
                personID: index,
                characterName: "Character \(index)",
                personName: "Actor \(index)",
                gender: .unknown,
                order: index - 1
            )
        }

        let crewMembers = (1 ... 2).map { index in
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
            id: 456,
            cast: castMembers,
            crew: crewMembers
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers.count == 3)
        #expect(result.crewMembers.count == 2)
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
            personID: 17419,
            characterName: "Eleven",
            personName: "Millie Bobby Brown",
            profileURLSet: nil,
            gender: .female,
            order: 0
        )

        let crewMemberDetails = CrewMemberDetails(
            id: "crew-1",
            personID: 12345,
            personName: "The Duffer Brothers",
            job: "Creator",
            profileURLSet: nil,
            gender: .male,
            department: "Writing"
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

    @Test("Preserves order of cast and crew members")
    func preservesOrder() {
        let castMembers = [
            CastMemberDetails(
                id: "cast-a",
                personID: 1,
                characterName: "First",
                personName: "Actor A",
                gender: .unknown,
                order: 0
            ),
            CastMemberDetails(
                id: "cast-b",
                personID: 2,
                characterName: "Second",
                personName: "Actor B",
                gender: .unknown,
                order: 1
            ),
            CastMemberDetails(
                id: "cast-c",
                personID: 3,
                characterName: "Third",
                personName: "Actor C",
                gender: .unknown,
                order: 2
            )
        ]

        let creditsDetails = CreditsDetails(
            id: 123,
            cast: castMembers,
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers[0].id == "cast-a")
        #expect(result.castMembers[1].id == "cast-b")
        #expect(result.castMembers[2].id == "cast-c")
    }

}
