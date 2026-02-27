//
//  PersonPreviewMapperTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TMDb
import TrendingDomain

@Suite("PersonPreviewMapper Tests")
struct PersonPreviewMapperTests {

    private let mapper = PersonPreviewMapper()

    @Test("Maps all properties from TMDb PersonListItem to PersonPreview")
    func mapsAllProperties() throws {
        let profilePath = try #require(URL(string: "https://example.com/profile.jpg"))

        let tmdbPerson = PersonListItem(
            id: 287,
            name: "Brad Pitt",
            originalName: "Brad Pitt",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: profilePath,
            popularity: 54.123,
            knownFor: [],
            isAdultOnly: false
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.id == 287)
        #expect(result.name == "Brad Pitt")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.profilePath == profilePath)
        #expect(result.initials == "BP")
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let tmdbPerson = PersonListItem(
            id: 287,
            name: "Brad Pitt",
            originalName: "Brad Pitt",
            knownForDepartment: nil,
            gender: .unknown,
            profilePath: nil,
            popularity: nil,
            knownFor: nil,
            isAdultOnly: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.id == 287)
        #expect(result.name == "Brad Pitt")
        #expect(result.knownForDepartment == nil)
        #expect(result.gender == .unknown)
        #expect(result.profilePath == nil)
    }

    @Test("Maps female gender correctly")
    func mapsFemaleGender() {
        let tmdbPerson = PersonListItem(
            id: 1245,
            name: "Scarlett Johansson",
            originalName: "Scarlett Johansson",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .female)
    }

    @Test("Maps male gender correctly")
    func mapsMaleGender() {
        let tmdbPerson = PersonListItem(
            id: 287,
            name: "Brad Pitt",
            originalName: "Brad Pitt",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .male)
    }

    @Test("Maps other gender correctly")
    func mapsOtherGender() {
        let tmdbPerson = PersonListItem(
            id: 999,
            name: "Test Person",
            originalName: "Test Person",
            knownForDepartment: nil,
            gender: .other,
            profilePath: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .other)
    }

    @Test("Maps unknown gender correctly")
    func mapsUnknownGender() {
        let tmdbPerson = PersonListItem(
            id: 999,
            name: "Test Person",
            originalName: "Test Person",
            knownForDepartment: nil,
            gender: .unknown,
            profilePath: nil
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.gender == .unknown)
    }

    @Test("Maps profile path when provided")
    func mapsProfilePathWhenProvided() throws {
        let profilePath = try #require(URL(string: "https://example.com/profile.jpg"))

        let tmdbPerson = PersonListItem(
            id: 123,
            name: "Test Person",
            originalName: "Test Person",
            knownForDepartment: nil,
            gender: .unknown,
            profilePath: profilePath
        )

        let result = mapper.map(tmdbPerson)

        #expect(result.profilePath == profilePath)
    }

    @Test("Maps different known for departments")
    func mapsDifferentKnownForDepartments() {
        let departments = ["Acting", "Directing", "Writing", "Production", "Crew"]

        for department in departments {
            let tmdbPerson = PersonListItem(
                id: 123,
                name: "Test Person",
                originalName: "Test Person",
                knownForDepartment: department,
                gender: .unknown,
                profilePath: nil
            )

            let result = mapper.map(tmdbPerson)

            #expect(result.knownForDepartment == department)
        }
    }

}
