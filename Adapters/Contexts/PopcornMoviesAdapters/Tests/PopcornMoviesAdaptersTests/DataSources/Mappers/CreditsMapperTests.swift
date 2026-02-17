//
//  CreditsMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("CreditsMapper Tests")
struct CreditsMapperTests {

    private let mapper = CreditsMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let castProfilePath = try #require(URL(string: "https://tmdb.example/cast.jpg"))
        let crewProfilePath = try #require(URL(string: "https://tmdb.example/crew.jpg"))

        let tmdbCredits = TMDb.ShowCredits(
            id: 550,
            cast: [
                TMDb.CastMember(
                    id: 819,
                    creditID: "52fe4250c3a36847f80149f3",
                    name: "Edward Norton",
                    character: "The Narrator",
                    gender: .male,
                    profilePath: castProfilePath,
                    order: 0
                )
            ],
            crew: [
                TMDb.CrewMember(
                    id: 7467,
                    creditID: "52fe4250c3a36847f8014a05",
                    name: "David Fincher",
                    job: "Director",
                    department: "Directing",
                    gender: .male,
                    profilePath: crewProfilePath
                )
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.id == 550)
        #expect(result.cast.count == 1)
        #expect(result.crew.count == 1)
        #expect(result.cast[0].personName == "Edward Norton")
        #expect(result.crew[0].personName == "David Fincher")
    }

    @Test("map handles empty cast array")
    func mapHandlesEmptyCastArray() {
        let tmdbCredits = TMDb.ShowCredits(
            id: 550,
            cast: [],
            crew: [
                TMDb.CrewMember(
                    id: 7467,
                    creditID: "abc",
                    name: "Director",
                    job: "Director",
                    department: "Directing",
                    gender: .male,
                    profilePath: nil
                )
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.cast.isEmpty)
        #expect(result.crew.count == 1)
    }

    @Test("map handles empty crew array")
    func mapHandlesEmptyCrewArray() {
        let tmdbCredits = TMDb.ShowCredits(
            id: 550,
            cast: [
                TMDb.CastMember(
                    id: 819,
                    creditID: "abc",
                    name: "Actor",
                    character: "Character",
                    gender: .male,
                    profilePath: nil,
                    order: 0
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
        let tmdbCredits = TMDb.ShowCredits(
            id: 550,
            cast: [],
            crew: []
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.id == 550)
        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    @Test("map converts multiple cast members")
    func mapConvertsMultipleCastMembers() {
        let tmdbCredits = TMDb.ShowCredits(
            id: 550,
            cast: [
                TMDb.CastMember(
                    id: 819,
                    creditID: "credit1",
                    name: "Edward Norton",
                    character: "The Narrator",
                    gender: .male,
                    profilePath: nil,
                    order: 0
                ),
                TMDb.CastMember(
                    id: 287,
                    creditID: "credit2",
                    name: "Brad Pitt",
                    character: "Tyler Durden",
                    gender: .male,
                    profilePath: nil,
                    order: 1
                ),
                TMDb.CastMember(
                    id: 1283,
                    creditID: "credit3",
                    name: "Helena Bonham Carter",
                    character: "Marla Singer",
                    gender: .female,
                    profilePath: nil,
                    order: 2
                )
            ],
            crew: []
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.cast.count == 3)
        #expect(result.cast[0].personName == "Edward Norton")
        #expect(result.cast[1].personName == "Brad Pitt")
        #expect(result.cast[2].personName == "Helena Bonham Carter")
    }

    @Test("map converts multiple crew members")
    func mapConvertsMultipleCrewMembers() {
        let tmdbCredits = TMDb.ShowCredits(
            id: 550,
            cast: [],
            crew: [
                TMDb.CrewMember(
                    id: 7467,
                    creditID: "crew1",
                    name: "David Fincher",
                    job: "Director",
                    department: "Directing",
                    gender: .male,
                    profilePath: nil
                ),
                TMDb.CrewMember(
                    id: 7468,
                    creditID: "crew2",
                    name: "Jim Uhls",
                    job: "Screenplay",
                    department: "Writing",
                    gender: .male,
                    profilePath: nil
                )
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.crew.count == 2)
        #expect(result.crew[0].personName == "David Fincher")
        #expect(result.crew[1].personName == "Jim Uhls")
    }

}
