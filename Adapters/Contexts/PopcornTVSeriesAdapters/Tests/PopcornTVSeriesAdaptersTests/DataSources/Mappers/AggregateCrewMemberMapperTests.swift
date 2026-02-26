//
//  AggregateCrewMemberMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("AggregateCrewMemberMapper Tests")
struct AggregateCrewMemberMapperTests {

    private let mapper = AggregateCrewMemberMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))

        let dto = TMDb.AggregateCrewMember(
            id: 1_222_585,
            name: "Matt Duffer",
            originalName: "Matt Duffer",
            gender: .male,
            profilePath: profilePath,
            jobs: [
                TMDb.CrewJob(creditID: "cj-1", job: "Creator", episodeCount: 34),
                TMDb.CrewJob(creditID: "cj-2", job: "Executive Producer", episodeCount: 34)
            ],
            knownForDepartment: "Production",
            isAdultOnly: false,
            totalEpisodeCount: 34,
            popularity: 10.0
        )

        let result = mapper.map(dto)

        #expect(result.id == 1_222_585)
        #expect(result.name == "Matt Duffer")
        #expect(result.profilePath == profilePath)
        #expect(result.gender == .male)
        #expect(result.department == "Production")
        #expect(result.jobs.count == 2)
        #expect(result.jobs[0].creditID == "cj-1")
        #expect(result.jobs[0].job == "Creator")
        #expect(result.jobs[0].episodeCount == 34)
        #expect(result.jobs[1].creditID == "cj-2")
        #expect(result.jobs[1].job == "Executive Producer")
        #expect(result.jobs[1].episodeCount == 34)
        #expect(result.totalEpisodeCount == 34)
    }

    @Test("map handles nil department with Other fallback")
    func mapHandlesNilDepartmentWithOtherFallback() {
        let dto = TMDb.AggregateCrewMember(
            id: 1_222_585,
            name: "Matt Duffer",
            originalName: "Matt Duffer",
            gender: .male,
            profilePath: nil,
            jobs: [TMDb.CrewJob(creditID: "cj-1", job: "Creator", episodeCount: 34)],
            knownForDepartment: nil,
            isAdultOnly: false,
            totalEpisodeCount: 34,
            popularity: nil
        )

        let result = mapper.map(dto)

        #expect(result.department == "Other")
    }

    @Test("map handles nil profile path")
    func mapHandlesNilProfilePath() {
        let dto = TMDb.AggregateCrewMember(
            id: 1_222_585,
            name: "Matt Duffer",
            originalName: "Matt Duffer",
            gender: .male,
            profilePath: nil,
            jobs: [TMDb.CrewJob(creditID: "cj-1", job: "Creator", episodeCount: 34)],
            knownForDepartment: "Production",
            isAdultOnly: false,
            totalEpisodeCount: 34,
            popularity: nil
        )

        let result = mapper.map(dto)

        #expect(result.profilePath == nil)
    }

    @Test("map handles empty jobs array")
    func mapHandlesEmptyJobsArray() {
        let dto = TMDb.AggregateCrewMember(
            id: 1_222_585,
            name: "Matt Duffer",
            originalName: "Matt Duffer",
            gender: .male,
            profilePath: nil,
            jobs: [],
            knownForDepartment: "Production",
            isAdultOnly: false,
            totalEpisodeCount: 0,
            popularity: nil
        )

        let result = mapper.map(dto)

        #expect(result.jobs.isEmpty)
        #expect(result.totalEpisodeCount == 0)
    }

    @Test("map handles nil gender as unknown")
    func mapHandlesNilGenderAsUnknown() {
        let dto = TMDb.AggregateCrewMember(
            id: 1_222_585,
            name: "Unknown Person",
            originalName: "Unknown Person",
            gender: .unknown,
            profilePath: nil,
            jobs: [TMDb.CrewJob(creditID: "cj-1", job: "Job", episodeCount: 1)],
            knownForDepartment: "Production",
            isAdultOnly: nil,
            totalEpisodeCount: 1,
            popularity: nil
        )

        let result = mapper.map(dto)

        #expect(result.gender == .unknown)
    }

}
