//
//  GenreMapperTests.swift
//  PopcornGenresAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain
@testable import PopcornGenresAdapters
import Testing
import TMDb

@Suite("GenreMapper Tests")
struct GenreMapperTests {

    private let mapper = GenreMapper()

    @Test("Maps genre id from TMDb to GenresDomain")
    func mapsGenreIdFromTMDbToDomain() {
        let tmdbGenre = TMDb.Genre(id: 28, name: "Action")

        let result = mapper.map(tmdbGenre)

        #expect(result.id == 28)
    }

    @Test("Maps genre name from TMDb to GenresDomain")
    func mapsGenreNameFromTMDbToDomain() {
        let tmdbGenre = TMDb.Genre(id: 28, name: "Action")

        let result = mapper.map(tmdbGenre)

        #expect(result.name == "Action")
    }

    @Test("Maps multiple genres correctly")
    func mapsMultipleGenres() {
        let tmdbGenres = [
            TMDb.Genre(id: 28, name: "Action"),
            TMDb.Genre(id: 878, name: "Science Fiction"),
            TMDb.Genre(id: 12, name: "Adventure")
        ]

        let results = tmdbGenres.map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 28)
        #expect(results[0].name == "Action")
        #expect(results[1].id == 878)
        #expect(results[1].name == "Science Fiction")
        #expect(results[2].id == 12)
        #expect(results[2].name == "Adventure")
    }

    @Test("Maps genre with special characters in name")
    func mapsGenreWithSpecialCharacters() {
        let tmdbGenre = TMDb.Genre(id: 10749, name: "Romance & Drama")

        let result = mapper.map(tmdbGenre)

        #expect(result.id == 10749)
        #expect(result.name == "Romance & Drama")
    }

}
