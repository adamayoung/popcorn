//
//  GenreMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("GenreMapper Tests")
struct GenreMapperTests {

    private let mapper = GenreMapper()

    @Test("Maps genre from TMDb to MoviesDomain")
    func mapsGenreFromTMDbToDomain() {
        let tmdbGenre = TMDb.Genre(id: 28, name: "Action")

        let result = mapper.map(tmdbGenre)

        #expect(result.id == 28)
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

}
