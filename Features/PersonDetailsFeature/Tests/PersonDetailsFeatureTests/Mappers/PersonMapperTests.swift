//
//  PersonMapperTests.swift
//  PersonDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import PeopleApplication
@testable import PersonDetailsFeature
import Testing

@Suite("PersonMapper Tests")
struct PersonMapperTests {

    private let mapper = PersonMapper()

    @Test("Maps PersonDetails to Person with all properties")
    func mapsPersonDetailsWithAllProperties() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let details = PersonDetails(
            id: 83271,
            name: "Glen Powell",
            biography: "Glen Powell is an American actor known for his roles in action films.",
            knownForDepartment: "Acting",
            gender: .male,
            profileURLSet: profileURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 83271)
        #expect(result.name == "Glen Powell")
        #expect(result.biography == "Glen Powell is an American actor known for his roles in action films.")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.profileURL == URL(string: "https://example.com/detail.jpg"))
    }

    @Test("Maps PersonDetails with nil profile URL set")
    func mapsPersonDetailsWithNilProfileURLSet() {
        let details = PersonDetails(
            id: 123,
            name: "Test Person",
            biography: "Test biography",
            knownForDepartment: "Directing",
            gender: .female
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.name == "Test Person")
        #expect(result.biography == "Test biography")
        #expect(result.knownForDepartment == "Directing")
        #expect(result.gender == .female)
        #expect(result.profileURL == nil)
    }

    @Test("Maps female gender correctly")
    func mapsFemaleGender() {
        let details = PersonDetails(
            id: 1,
            name: "Test",
            biography: "",
            knownForDepartment: "",
            gender: .female
        )

        let result = mapper.map(details)

        #expect(result.gender == .female)
    }

    @Test("Maps male gender correctly")
    func mapsMaleGender() {
        let details = PersonDetails(
            id: 1,
            name: "Test",
            biography: "",
            knownForDepartment: "",
            gender: .male
        )

        let result = mapper.map(details)

        #expect(result.gender == .male)
    }

    @Test("Maps other gender correctly")
    func mapsOtherGender() {
        let details = PersonDetails(
            id: 1,
            name: "Test",
            biography: "",
            knownForDepartment: "",
            gender: .other
        )

        let result = mapper.map(details)

        #expect(result.gender == .other)
    }

    @Test("Maps unknown gender correctly")
    func mapsUnknownGender() {
        let details = PersonDetails(
            id: 1,
            name: "Test",
            biography: "",
            knownForDepartment: "",
            gender: .unknown
        )

        let result = mapper.map(details)

        #expect(result.gender == .unknown)
    }

}
