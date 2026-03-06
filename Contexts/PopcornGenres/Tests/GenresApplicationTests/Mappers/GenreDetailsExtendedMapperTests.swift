//
//  GenreDetailsExtendedMapperTests.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import GenresApplication
import GenresDomain
import Testing

@Suite("GenreDetailsExtendedMapper")
struct GenreDetailsExtendedMapperTests {

    let mapper = GenreDetailsExtendedMapper()

    @Test("map returns genre with all fields")
    func mapReturnsGenreWithAllFields() throws {
        let genre = Genre.mock(id: 28, name: "Action")
        let imagesConfiguration = ImagesConfiguration.mock()
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))
        let backdropURLSet = imagesConfiguration.backdropURLSet(for: backdropPath)

        let result = mapper.map(genre, backdropURLSet: backdropURLSet)

        #expect(result.id == 28)
        #expect(result.name == "Action")
        #expect(result.backdropURLSet == backdropURLSet)
    }

    @Test("map returns genre with nil backdrop")
    func mapReturnsGenreWithNilBackdrop() {
        let genre = Genre.mock(id: 35, name: "Comedy")

        let result = mapper.map(genre, backdropURLSet: nil)

        #expect(result.id == 35)
        #expect(result.name == "Comedy")
        #expect(result.backdropURLSet == nil)
    }

    @Test("color is deterministic for same ID")
    func colorIsDeterministicForSameID() {
        let color1 = GenreDetailsExtendedMapper.color(forGenreID: 28)
        let color2 = GenreDetailsExtendedMapper.color(forGenreID: 28)

        #expect(color1 == color2)
    }

    @Test("color differs for different IDs")
    func colorDiffersForDifferentIDs() {
        let color1 = GenreDetailsExtendedMapper.color(forGenreID: 28)
        let color2 = GenreDetailsExtendedMapper.color(forGenreID: 35)

        #expect(color1 != color2)
    }

}
