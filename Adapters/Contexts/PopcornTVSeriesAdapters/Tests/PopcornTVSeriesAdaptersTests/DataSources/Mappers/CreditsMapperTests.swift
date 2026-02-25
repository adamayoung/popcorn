//
//  CreditsMapperTests.swift
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

@Suite("CreditsMapper Tests")
struct CreditsMapperTests {

    private let mapper = CreditsMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let castProfilePath = try #require(URL(string: "https://tmdb.example/cast.jpg"))
        let crewProfilePath = try #require(URL(string: "https://tmdb.example/crew.jpg"))

        let tmdbCredits = TMDb.ShowCredits(
            id: 1396,
            cast: [
                TMDb.CastMember(
                    id: 17419,
                    creditID: "52542282760ee313280017f9",
                    name: "Bryan Cranston",
                    character: "Walter White",
                    gender: .male,
                    profilePath: castProfilePath,
                    order: 0
                )
            ],
            crew: [
                TMDb.CrewMember(
                    id: 66633,
                    creditID: "52542287760ee31328001af1",
                    name: "Vince Gilligan",
                    job: "Executive Producer",
                    department: "Production",
                    gender: .male,
                    profilePath: crewProfilePath
                )
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.id == 1396)
        #expect(result.cast.count == 1)
        #expect(result.crew.count == 1)
        #expect(result.cast[0].personName == "Bryan Cranston")
        #expect(result.crew[0].personName == "Vince Gilligan")
    }

    @Test("map handles empty cast array")
    func mapHandlesEmptyCastArray() {
        let tmdbCredits = TMDb.ShowCredits(
            id: 1396,
            cast: [],
            crew: [
                TMDb.CrewMember(
                    id: 66633,
                    creditID: "abc",
                    name: "Vince Gilligan",
                    job: "Executive Producer",
                    department: "Production",
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
            id: 1396,
            cast: [
                TMDb.CastMember(
                    id: 17419,
                    creditID: "abc",
                    name: "Bryan Cranston",
                    character: "Walter White",
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
            id: 1396,
            cast: [],
            crew: []
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.id == 1396)
        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    @Test("map converts multiple cast members")
    func mapConvertsMultipleCastMembers() {
        let tmdbCredits = TMDb.ShowCredits(
            id: 1396,
            cast: [
                TMDb.CastMember(
                    id: 17419,
                    creditID: "credit1",
                    name: "Bryan Cranston",
                    character: "Walter White",
                    gender: .male,
                    profilePath: nil,
                    order: 0
                ),
                TMDb.CastMember(
                    id: 84497,
                    creditID: "credit2",
                    name: "Aaron Paul",
                    character: "Jesse Pinkman",
                    gender: .male,
                    profilePath: nil,
                    order: 1
                ),
                TMDb.CastMember(
                    id: 134_531,
                    creditID: "credit3",
                    name: "Anna Gunn",
                    character: "Skyler White",
                    gender: .female,
                    profilePath: nil,
                    order: 2
                )
            ],
            crew: []
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.cast.count == 3)
        #expect(result.cast[0].personName == "Bryan Cranston")
        #expect(result.cast[1].personName == "Aaron Paul")
        #expect(result.cast[2].personName == "Anna Gunn")
    }

    @Test("map converts multiple crew members")
    func mapConvertsMultipleCrewMembers() {
        let tmdbCredits = TMDb.ShowCredits(
            id: 1396,
            cast: [],
            crew: [
                TMDb.CrewMember(
                    id: 66633,
                    creditID: "crew1",
                    name: "Vince Gilligan",
                    job: "Executive Producer",
                    department: "Production",
                    gender: .male,
                    profilePath: nil
                ),
                TMDb.CrewMember(
                    id: 1_223_202,
                    creditID: "crew2",
                    name: "Mark Johnson",
                    job: "Executive Producer",
                    department: "Production",
                    gender: .male,
                    profilePath: nil
                )
            ]
        )

        let result = mapper.map(tmdbCredits)

        #expect(result.crew.count == 2)
        #expect(result.crew[0].personName == "Vince Gilligan")
        #expect(result.crew[1].personName == "Mark Johnson")
    }

}
