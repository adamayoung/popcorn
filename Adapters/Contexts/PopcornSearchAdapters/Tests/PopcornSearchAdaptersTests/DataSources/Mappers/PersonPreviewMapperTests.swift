//
//  PersonPreviewMapperTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import PopcornSearchAdapters
import SearchDomain
import Testing
import TMDb

@Suite("PersonPreviewMapper Tests")
struct PersonPreviewMapperTests {

    @Test("map converts TMDb PersonListItem to PersonPreview with all fields")
    func mapConvertsTMDbPersonListItemToPersonPreviewWithAllFields() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))
        let personListItem = PersonListItem(
            id: 555,
            name: "John Doe",
            originalName: "John Doe",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: profilePath,
            popularity: 50.0,
            knownFor: nil,
            isAdultOnly: false
        )

        let mapper = PersonPreviewMapper()
        let result = mapper.map(personListItem)

        #expect(result.id == 555)
        #expect(result.name == "John Doe")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.profilePath == profilePath)
    }

    @Test("map converts TMDb PersonListItem with nil optional fields")
    func mapConvertsTMDbPersonListItemWithNilOptionalFields() {
        let personListItem = PersonListItem(
            id: 666,
            name: "Jane Doe",
            originalName: "Jane Doe",
            knownForDepartment: nil,
            gender: .female,
            profilePath: nil,
            popularity: nil,
            knownFor: nil,
            isAdultOnly: nil
        )

        let mapper = PersonPreviewMapper()
        let result = mapper.map(personListItem)

        #expect(result.id == 666)
        #expect(result.name == "Jane Doe")
        #expect(result.knownForDepartment == nil)
        #expect(result.gender == .female)
        #expect(result.profilePath == nil)
    }

    @Test("map maps unknown gender correctly")
    func mapMapsUnknownGenderCorrectly() {
        let personListItem = PersonListItem(
            id: 777,
            name: "Unknown Person",
            originalName: "Unknown Person",
            knownForDepartment: "Directing",
            gender: .unknown,
            profilePath: nil
        )

        let mapper = PersonPreviewMapper()
        let result = mapper.map(personListItem)

        #expect(result.gender == .unknown)
    }

    @Test("map maps female gender correctly")
    func mapMapsFemaleGenderCorrectly() {
        let personListItem = PersonListItem(
            id: 888,
            name: "Female Person",
            originalName: "Female Person",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: nil
        )

        let mapper = PersonPreviewMapper()
        let result = mapper.map(personListItem)

        #expect(result.gender == .female)
    }

    @Test("map maps male gender correctly")
    func mapMapsMaleGenderCorrectly() {
        let personListItem = PersonListItem(
            id: 999,
            name: "Male Person",
            originalName: "Male Person",
            knownForDepartment: "Writing",
            gender: .male,
            profilePath: nil
        )

        let mapper = PersonPreviewMapper()
        let result = mapper.map(personListItem)

        #expect(result.gender == .male)
    }

    @Test("map maps other gender correctly")
    func mapMapsOtherGenderCorrectly() {
        let personListItem = PersonListItem(
            id: 1000,
            name: "Other Person",
            originalName: "Other Person",
            knownForDepartment: "Production",
            gender: .other,
            profilePath: nil
        )

        let mapper = PersonPreviewMapper()
        let result = mapper.map(personListItem)

        #expect(result.gender == .other)
    }

}
