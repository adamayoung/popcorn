//
//  GenreMapperTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import GenresDomain
@testable import PopcornDiscoverAdapters
import Testing

@Suite("GenreMapper Tests")
struct GenreMapperTests {

    private let mapper = GenreMapper()

    @Test("Maps genre ID correctly")
    func mapsGenreIDCorrectly() {
        let sourceGenre = GenresDomain.Genre(id: 28, name: "Action")

        let result = mapper.map(sourceGenre)

        #expect(result.id == 28)
    }

    @Test("Maps genre name correctly")
    func mapsGenreNameCorrectly() {
        let sourceGenre = GenresDomain.Genre(id: 28, name: "Action")

        let result = mapper.map(sourceGenre)

        #expect(result.name == "Action")
    }

    @Test("Maps genre with all properties")
    func mapsGenreWithAllProperties() {
        let sourceGenre = GenresDomain.Genre(id: 18, name: "Drama")

        let result = mapper.map(sourceGenre)

        #expect(result.id == 18)
        #expect(result.name == "Drama")
    }

    @Test("Maps genre with special characters in name")
    func mapsGenreWithSpecialCharactersInName() {
        let sourceGenre = GenresDomain.Genre(id: 10759, name: "Action & Adventure")

        let result = mapper.map(sourceGenre)

        #expect(result.id == 10759)
        #expect(result.name == "Action & Adventure")
    }

    @Test("Maps genre with empty name")
    func mapsGenreWithEmptyName() {
        let sourceGenre = GenresDomain.Genre(id: 99999, name: "")

        let result = mapper.map(sourceGenre)

        #expect(result.id == 99999)
        #expect(result.name == "")
    }

    @Test("Maps multiple genres correctly")
    func mapsMultipleGenresCorrectly() {
        let sourceGenres: [GenresDomain.Genre] = [
            Genre(id: 28, name: "Action"),
            Genre(id: 12, name: "Adventure"),
            Genre(id: 35, name: "Comedy")
        ]

        let results = sourceGenres.map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 28)
        #expect(results[0].name == "Action")
        #expect(results[1].id == 12)
        #expect(results[1].name == "Adventure")
        #expect(results[2].id == 35)
        #expect(results[2].name == "Comedy")
    }

}
