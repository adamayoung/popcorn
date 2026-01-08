//
//  MovieCreditsToolMapperTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
import Testing

@testable import IntelligenceInfrastructure

@Suite("MovieCreditsToolMapper")
struct MovieCreditsToolMapperTests {

    let mapper = MovieCreditsToolMapper()

    @Test("map returns correct id")
    func mapReturnsCorrectID() {
        let credits = Credits.mock(id: 789)

        let result = mapper.map(credits, limit: 10)

        #expect(result.id == 789)
    }

    @Test("map returns cast members")
    func mapReturnsCastMembers() {
        let cast = [
            CastMember.mock(id: "cast-1", personID: 100, characterName: "Hero", personName: "Actor One"),
            CastMember.mock(id: "cast-2", personID: 101, characterName: "Villain", personName: "Actor Two")
        ]
        let credits = Credits.mock(cast: cast, crew: [])

        let result = mapper.map(credits, limit: 10)

        #expect(result.cast.count == 2)
        #expect(result.cast[0].id == "cast-1")
        #expect(result.cast[0].personID == 100)
        #expect(result.cast[0].characterName == "Hero")
        #expect(result.cast[0].personName == "Actor One")
    }

    @Test("map returns crew members")
    func mapReturnsCrewMembers() {
        let crew = [
            CrewMember.mock(id: "crew-1", personID: 200, personName: "Director One", job: "Director"),
            CrewMember.mock(id: "crew-2", personID: 201, personName: "Writer One", job: "Writer")
        ]
        let credits = Credits.mock(cast: [], crew: crew)

        let result = mapper.map(credits, limit: 10)

        #expect(result.crew.count == 2)
        #expect(result.crew[0].id == "crew-1")
        #expect(result.crew[0].personID == 200)
        #expect(result.crew[0].personName == "Director One")
        #expect(result.crew[0].job == "Director")
    }

    @Test("map limits cast members to specified limit")
    func mapLimitsCastMembersToSpecifiedLimit() {
        let cast = (1 ... 20).map { index in
            CastMember.mock(
                id: "cast-\(index)",
                personID: index,
                characterName: "Character \(index)",
                personName: "Actor \(index)"
            )
        }
        let credits = Credits.mock(cast: cast, crew: [])

        let result = mapper.map(credits, limit: 5)

        #expect(result.cast.count == 5)
        #expect(result.cast[0].id == "cast-1")
        #expect(result.cast[4].id == "cast-5")
    }

    @Test("map limits crew members to specified limit")
    func mapLimitsCrewMembersToSpecifiedLimit() {
        let crew = (1 ... 15).map { index in
            CrewMember.mock(id: "crew-\(index)", personID: index, personName: "Crew \(index)", job: "Job \(index)")
        }
        let credits = Credits.mock(cast: [], crew: crew)

        let result = mapper.map(credits, limit: 3)

        #expect(result.crew.count == 3)
        #expect(result.crew[0].id == "crew-1")
        #expect(result.crew[2].id == "crew-3")
    }

    @Test("map handles empty cast and crew")
    func mapHandlesEmptyCastAndCrew() {
        let credits = Credits.mock(cast: [], crew: [])

        let result = mapper.map(credits, limit: 10)

        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

}
