//
//  CastMemberMapperTests.swift
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

@Suite("CastMemberMapper Tests")
struct CastMemberMapperTests {

    private let mapper = CastMemberMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))
        let tmdbCastMember = TMDb.CastMember(
            id: 819,
            creditID: "52fe4250c3a36847f80149f3",
            name: "Edward Norton",
            character: "The Narrator",
            gender: .male,
            profilePath: profilePath,
            order: 0
        )

        let result = mapper.map(tmdbCastMember)

        #expect(result.id == "52fe4250c3a36847f80149f3")
        #expect(result.personID == 819)
        #expect(result.characterName == "The Narrator")
        #expect(result.personName == "Edward Norton")
        #expect(result.profilePath == profilePath)
        #expect(result.gender == .male)
        #expect(result.order == 0)
        #expect(result.initials == "EN")
    }

    @Test("map converts female gender correctly")
    func mapConvertsFemaleGenderCorrectly() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))
        let tmdbCastMember = TMDb.CastMember(
            id: 1283,
            creditID: "52fe4250c3a36847f80149fd",
            name: "Helena Bonham Carter",
            character: "Marla Singer",
            gender: .female,
            profilePath: profilePath,
            order: 2
        )

        let result = mapper.map(tmdbCastMember)

        #expect(result.gender == .female)
    }

    @Test("map handles nil profile path")
    func mapHandlesNilProfilePath() {
        let tmdbCastMember = TMDb.CastMember(
            id: 819,
            creditID: "52fe4250c3a36847f80149f3",
            name: "Edward Norton",
            character: "The Narrator",
            gender: .male,
            profilePath: nil,
            order: 0
        )

        let result = mapper.map(tmdbCastMember)

        #expect(result.profilePath == nil)
    }

    @Test("map handles default unknown gender")
    func mapHandlesDefaultUnknownGender() {
        let tmdbCastMember = TMDb.CastMember(
            id: 819,
            creditID: "52fe4250c3a36847f80149f3",
            name: "Unknown Actor",
            character: "Mystery Character",
            profilePath: nil,
            order: 5
        )

        let result = mapper.map(tmdbCastMember)

        #expect(result.gender == .unknown)
    }

    @Test("map converts other gender correctly")
    func mapConvertsOtherGenderCorrectly() {
        let tmdbCastMember = TMDb.CastMember(
            id: 100,
            creditID: "abc123",
            name: "Actor Name",
            character: "Character Name",
            gender: .other,
            profilePath: nil,
            order: 3
        )

        let result = mapper.map(tmdbCastMember)

        #expect(result.gender == .other)
    }

    @Test("map converts unknown gender correctly")
    func mapConvertsUnknownGenderCorrectly() {
        let tmdbCastMember = TMDb.CastMember(
            id: 100,
            creditID: "abc123",
            name: "Actor Name",
            character: "Character Name",
            gender: .unknown,
            profilePath: nil,
            order: 3
        )

        let result = mapper.map(tmdbCastMember)

        #expect(result.gender == .unknown)
    }

    @Test("map preserves order value")
    func mapPreservesOrderValue() {
        let tmdbCastMember = TMDb.CastMember(
            id: 100,
            creditID: "abc123",
            name: "Actor",
            character: "Character",
            gender: .male,
            profilePath: nil,
            order: 15
        )

        let result = mapper.map(tmdbCastMember)

        #expect(result.order == 15)
    }

}
