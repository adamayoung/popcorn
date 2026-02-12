//
//  PersonMapperTests.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain
@testable import PopcornPeopleAdapters
import Testing
import TMDb

@Suite("PersonMapper Tests")
struct PersonMapperTests {

    private let mapper = PersonMapper()

    @Test("Maps all properties from TMDb Person to PeopleDomain Person")
    func mapsAllProperties() throws {
        let profilePath = try #require(URL(string: "/path/to/profile.jpg"))
        let tmdbPerson = TMDb.Person(
            id: 287,
            name: "Brad Pitt",
            alsoKnownAs: ["William Bradley Pitt", "Brad Pitt"],
            knownForDepartment: "Acting",
            biography: "William Bradley Pitt is an American actor and film producer.",
            birthday: Date(timeIntervalSince1970: -199_238_400), // 1963-12-18
            deathday: nil,
            gender: .male,
            placeOfBirth: "Shawnee, Oklahoma, USA",
            profilePath: profilePath,
            popularity: 75.123,
            imdbID: "nm0000093",
            homepageURL: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.id == 287)
        #expect(result.name == "Brad Pitt")
        #expect(result.biography == "William Bradley Pitt is an American actor and film producer.")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.profilePath == profilePath)
    }

    @Test("Maps with nil biography to empty string")
    func mapsNilBiographyToEmptyString() {
        let tmdbPerson = TMDb.Person(
            id: 31,
            name: "Tom Hanks",
            knownForDepartment: "Acting",
            biography: nil,
            gender: .male
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.id == 31)
        #expect(result.name == "Tom Hanks")
        #expect(result.biography == "")
    }

    @Test("Maps with nil knownForDepartment to empty string")
    func mapsNilKnownForDepartmentToEmptyString() {
        let tmdbPerson = TMDb.Person(
            id: 287,
            name: "Brad Pitt",
            knownForDepartment: nil,
            biography: "Biography text",
            gender: .male
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.knownForDepartment == "")
    }

    @Test("Maps nil profilePath correctly")
    func mapsNilProfilePathCorrectly() {
        let tmdbPerson = TMDb.Person(
            id: 287,
            name: "Brad Pitt",
            knownForDepartment: "Acting",
            biography: "Biography",
            gender: .male,
            profilePath: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.profilePath == nil)
    }

    @Test("Maps female gender correctly")
    func mapsFemaleGenderCorrectly() {
        let tmdbPerson = TMDb.Person(
            id: 1,
            name: "Test Person",
            gender: .female
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .female)
    }

    @Test("Maps male gender correctly")
    func mapsMaleGenderCorrectly() {
        let tmdbPerson = TMDb.Person(
            id: 287,
            name: "Brad Pitt",
            gender: .male
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .male)
    }

    @Test("Maps unknown gender correctly")
    func mapsUnknownGenderCorrectly() {
        let tmdbPerson = TMDb.Person(
            id: 1,
            name: "Unknown Person",
            gender: .unknown
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .unknown)
    }

    @Test("Maps other gender correctly")
    func mapsOtherGenderCorrectly() {
        let tmdbPerson = TMDb.Person(
            id: 1,
            name: "Non-binary Person",
            gender: .other
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .other)
    }

    @Test("Maps Tom Hanks test data correctly")
    func mapsTomHanksTestData() throws {
        let profilePath = try #require(URL(string: "/profile/tom-hanks.jpg"))
        let tmdbPerson = TMDb.Person(
            id: 31,
            name: "Tom Hanks",
            alsoKnownAs: ["Thomas Jeffrey Hanks"],
            knownForDepartment: "Acting",
            biography: "Thomas Jeffrey Hanks is an American actor and filmmaker.",
            birthday: Date(timeIntervalSince1970: -425_174_400), // 1956-07-09
            deathday: nil,
            gender: .male,
            placeOfBirth: "Concord, California, USA",
            profilePath: profilePath,
            popularity: 82.456,
            imdbID: "nm0000158",
            homepageURL: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.id == 31)
        #expect(result.name == "Tom Hanks")
        #expect(result.biography == "Thomas Jeffrey Hanks is an American actor and filmmaker.")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.profilePath == profilePath)
    }

    @Test("Maps with all nil optional properties")
    func mapsWithAllNilOptionalProperties() {
        let tmdbPerson = TMDb.Person(
            id: 999,
            name: "Minimal Person",
            alsoKnownAs: nil,
            knownForDepartment: nil,
            biography: nil,
            birthday: nil,
            deathday: nil,
            gender: .unknown,
            placeOfBirth: nil,
            profilePath: nil,
            popularity: nil,
            imdbID: nil,
            homepageURL: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.id == 999)
        #expect(result.name == "Minimal Person")
        #expect(result.biography == "")
        #expect(result.knownForDepartment == "")
        #expect(result.gender == .unknown)
        #expect(result.profilePath == nil)
    }

    @Test("Maps with empty biography string")
    func mapsWithEmptyBiographyString() {
        let tmdbPerson = TMDb.Person(
            id: 1,
            name: "Test Person",
            biography: "",
            gender: .male
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.biography == "")
    }

    @Test("Maps with empty knownForDepartment string")
    func mapsWithEmptyKnownForDepartmentString() {
        let tmdbPerson = TMDb.Person(
            id: 1,
            name: "Test Person",
            knownForDepartment: "",
            gender: .male
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.knownForDepartment == "")
    }

}
