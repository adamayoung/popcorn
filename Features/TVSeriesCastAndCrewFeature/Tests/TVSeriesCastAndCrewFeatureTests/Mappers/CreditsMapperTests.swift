//
//  CreditsMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesApplication
@testable import TVSeriesCastAndCrewFeature

@Suite("CreditsMapper Tests")
struct CreditsMapperTests {

    private let mapper = CreditsMapper()

    @Test("Maps AggregateCreditsDetails to Credits with all properties")
    func mapsAggregateCreditsDetailsWithAllProperties() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let castMemberDetails = AggregateCastMemberDetails(
            id: 17419,
            name: "Millie Bobby Brown",
            profileURLSet: profileURLSet,
            gender: .female,
            roles: [CastRoleDetails(creditID: "cast-1", character: "Eleven", episodeCount: 34)],
            totalEpisodeCount: 34
        )

        let crewMemberDetails = AggregateCrewMemberDetails(
            id: 1_222_585,
            name: "Matt Duffer",
            profileURLSet: profileURLSet,
            gender: .male,
            department: "Production",
            jobs: [CrewJobDetails(creditID: "crew-1", job: "Creator", episodeCount: 34)],
            totalEpisodeCount: 34
        )

        let creditsDetails = AggregateCreditsDetails(
            id: 66732,
            cast: [castMemberDetails],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 66732)
        #expect(result.castMembers.count == 1)
        #expect(result.crewMembers.count == 1)

        let castMember = result.castMembers[0]
        #expect(castMember.id == 17419)
        #expect(castMember.personName == "Millie Bobby Brown")
        #expect(castMember.profileURL == URL(string: "https://example.com/detail.jpg"))
        #expect(castMember.roles.count == 1)
        #expect(castMember.roles[0].character == "Eleven")
        #expect(castMember.roles[0].episodeCount == 34)
        #expect(castMember.totalEpisodeCount == 34)

        let crewMember = result.crewMembers[0]
        #expect(crewMember.id == 1_222_585)
        #expect(crewMember.personName == "Matt Duffer")
        #expect(crewMember.profileURL == URL(string: "https://example.com/detail.jpg"))
        #expect(crewMember.department == "Production")
        #expect(crewMember.jobs.count == 1)
        #expect(crewMember.jobs[0].job == "Creator")
        #expect(crewMember.jobs[0].episodeCount == 34)
        #expect(crewMember.totalEpisodeCount == 34)
    }

    @Test("Maps all cast members without limit")
    func mapsAllCastMembersWithoutLimit() {
        let castMembers = (1 ... 10).map { index in
            AggregateCastMemberDetails(
                id: index,
                name: "Actor \(index)",
                gender: .unknown,
                roles: [CastRoleDetails(creditID: "c-\(index)", character: "Char", episodeCount: 1)],
                totalEpisodeCount: 1
            )
        }

        let creditsDetails = AggregateCreditsDetails(
            id: 66732,
            cast: castMembers,
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers.count == 10)
    }

    @Test("Maps all crew members without limit")
    func mapsAllCrewMembersWithoutLimit() {
        let crewMembers = (1 ... 10).map { index in
            AggregateCrewMemberDetails(
                id: index,
                name: "Person \(index)",
                gender: .unknown,
                department: "Department \(index)",
                jobs: [CrewJobDetails(creditID: "j-\(index)", job: "Job", episodeCount: 1)],
                totalEpisodeCount: 1
            )
        }

        let creditsDetails = AggregateCreditsDetails(
            id: 66732,
            cast: [],
            crew: crewMembers
        )

        let result = mapper.map(creditsDetails)

        #expect(result.crewMembers.count == 10)
    }

    @Test("Maps with empty cast and crew arrays")
    func mapsWithEmptyArrays() {
        let creditsDetails = AggregateCreditsDetails(
            id: 66732,
            cast: [],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        #expect(result.id == 66732)
        #expect(result.castMembers.isEmpty)
        #expect(result.crewMembers.isEmpty)
    }

    @Test("Maps with nil profile URL sets")
    func mapsWithNilProfileURLSets() {
        let castMemberDetails = AggregateCastMemberDetails(
            id: 17419,
            name: "Millie Bobby Brown",
            profileURLSet: nil,
            gender: .female,
            roles: [CastRoleDetails(creditID: "cast-1", character: "Eleven", episodeCount: 34)],
            totalEpisodeCount: 34
        )

        let crewMemberDetails = AggregateCrewMemberDetails(
            id: 1_222_585,
            name: "Matt Duffer",
            profileURLSet: nil,
            gender: .male,
            department: "Production",
            jobs: [CrewJobDetails(creditID: "crew-1", job: "Creator", episodeCount: 34)],
            totalEpisodeCount: 34
        )

        let creditsDetails = AggregateCreditsDetails(
            id: 66732,
            cast: [castMemberDetails],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        #expect(result.castMembers[0].profileURL == nil)
        #expect(result.crewMembers[0].profileURL == nil)
    }

    @Test("Maps cast member with multiple roles")
    func mapsCastMemberWithMultipleRoles() {
        let castMemberDetails = AggregateCastMemberDetails(
            id: 17419,
            name: "Millie Bobby Brown",
            gender: .female,
            roles: [
                CastRoleDetails(creditID: "c-1", character: "Eleven", episodeCount: 30),
                CastRoleDetails(creditID: "c-2", character: "011", episodeCount: 4)
            ],
            totalEpisodeCount: 34
        )

        let creditsDetails = AggregateCreditsDetails(
            id: 66732,
            cast: [castMemberDetails],
            crew: []
        )

        let result = mapper.map(creditsDetails)

        let castMember = result.castMembers[0]
        #expect(castMember.roles.count == 2)
        #expect(castMember.roles[0].character == "Eleven")
        #expect(castMember.roles[1].character == "011")
    }

    @Test("Maps crew member with multiple jobs")
    func mapsCrewMemberWithMultipleJobs() {
        let crewMemberDetails = AggregateCrewMemberDetails(
            id: 111_581,
            name: "Shawn Levy",
            gender: .male,
            department: "Production",
            jobs: [
                CrewJobDetails(creditID: "j-1", job: "Executive Producer", episodeCount: 34),
                CrewJobDetails(creditID: "j-2", job: "Director", episodeCount: 6)
            ],
            totalEpisodeCount: 34
        )

        let creditsDetails = AggregateCreditsDetails(
            id: 66732,
            cast: [],
            crew: [crewMemberDetails]
        )

        let result = mapper.map(creditsDetails)

        let crewMember = result.crewMembers[0]
        #expect(crewMember.jobs.count == 2)
        #expect(crewMember.jobs[0].job == "Executive Producer")
        #expect(crewMember.jobs[1].job == "Director")
    }

}
