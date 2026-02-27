//
//  AggregateCreditsMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("AggregateCreditsMapper Tests")
struct AggregateCreditsMapperTests {

    private let mapper = AggregateCreditsMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))

        let tmdbCredits = TMDb.TVSeriesAggregateCredits(
            id: 66732,
            cast: [
                TMDb.AggregateCastMember(
                    id: 17419,
                    name: "Millie Bobby Brown",
                    originalName: "Millie Bobby Brown",
                    gender: .female,
                    profilePath: profilePath,
                    roles: [
                        TMDb.CastRole(creditID: "cr-1", character: "Eleven", episodeCount: 34)
                    ],
                    knownForDepartment: "Acting",
                    isAdultOnly: false,
                    totalEpisodeCount: 34,
                    popularity: 50.0
                )
            ],
            crew: [
                TMDb.AggregateCrewMember(
                    id: 1_222_585,
                    name: "Matt Duffer",
                    originalName: "Matt Duffer",
                    gender: .male,
                    profilePath: profilePath,
                    jobs: [
                        TMDb.CrewJob(creditID: "cj-1", job: "Creator", episodeCount: 34)
                    ],
                    knownForDepartment: "Production",
                    isAdultOnly: false,
                    totalEpisodeCount: 34,
                    popularity: 10.0
                )
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.id == 66732)
        #expect(result.cast.count == 1)
        #expect(result.crew.count == 1)
        #expect(result.cast[0].name == "Millie Bobby Brown")
        #expect(result.crew[0].name == "Matt Duffer")
    }

    @Test("map handles empty cast array")
    func mapHandlesEmptyCastArray() {
        let tmdbCredits = TMDb.TVSeriesAggregateCredits(
            id: 66732,
            cast: [],
            crew: [
                TMDb.AggregateCrewMember(
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
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.cast.isEmpty)
        #expect(result.crew.count == 1)
    }

    @Test("map handles empty crew array")
    func mapHandlesEmptyCrewArray() {
        let tmdbCredits = TMDb.TVSeriesAggregateCredits(
            id: 66732,
            cast: [
                TMDb.AggregateCastMember(
                    id: 17419,
                    name: "Millie Bobby Brown",
                    originalName: "Millie Bobby Brown",
                    gender: .female,
                    profilePath: nil,
                    roles: [TMDb.CastRole(creditID: "cr-1", character: "Eleven", episodeCount: 34)],
                    knownForDepartment: "Acting",
                    isAdultOnly: false,
                    totalEpisodeCount: 34,
                    popularity: nil
                )
            ],
            crew: []
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.cast.count == 1)
        #expect(result.crew.isEmpty)
    }

    @Test("map handles both empty arrays")
    func mapHandlesBothEmptyArrays() {
        let tmdbCredits = TMDb.TVSeriesAggregateCredits(
            id: 66732,
            cast: [],
            crew: []
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.id == 66732)
        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    @Test("map converts multiple cast members")
    func mapConvertsMultipleCastMembers() {
        let tmdbCredits = TMDb.TVSeriesAggregateCredits(
            id: 66732,
            cast: [
                makeCastMember(id: 17419, name: "Millie Bobby Brown", creditID: "cr-1"),
                makeCastMember(id: 37153, name: "David Harbour", creditID: "cr-2")
            ],
            crew: []
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.cast.count == 2)
        #expect(result.cast[0].name == "Millie Bobby Brown")
        #expect(result.cast[1].name == "David Harbour")
    }

    @Test("map converts multiple crew members")
    func mapConvertsMultipleCrewMembers() {
        let tmdbCredits = TMDb.TVSeriesAggregateCredits(
            id: 66732,
            cast: [],
            crew: [
                makeCrewMember(id: 1_222_585, name: "Matt Duffer", creditID: "cj-1"),
                makeCrewMember(id: 1_222_586, name: "Ross Duffer", creditID: "cj-2")
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.crew.count == 2)
        #expect(result.crew[0].name == "Matt Duffer")
        #expect(result.crew[1].name == "Ross Duffer")
    }

    // MARK: - Helpers

    private func makeCastMember(
        id: Int,
        name: String,
        creditID: String
    ) -> TMDb.AggregateCastMember {
        TMDb.AggregateCastMember(
            id: id,
            name: name,
            originalName: name,
            gender: .male,
            profilePath: nil,
            roles: [TMDb.CastRole(creditID: creditID, character: "Character", episodeCount: 10)],
            knownForDepartment: "Acting",
            isAdultOnly: false,
            totalEpisodeCount: 10,
            popularity: nil
        )
    }

    private func makeCrewMember(
        id: Int,
        name: String,
        creditID: String
    ) -> TMDb.AggregateCrewMember {
        TMDb.AggregateCrewMember(
            id: id,
            name: name,
            originalName: name,
            gender: .male,
            profilePath: nil,
            jobs: [TMDb.CrewJob(creditID: creditID, job: "Creator", episodeCount: 10)],
            knownForDepartment: "Production",
            isAdultOnly: false,
            totalEpisodeCount: 10,
            popularity: nil
        )
    }

}
