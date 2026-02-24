//
//  GenreMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("GenreMapper Tests")
struct GenreMapperTests {

    private let mapper = GenreMapper()

    @Test("Maps genre from TMDb to TVSeriesDomain")
    func mapsGenreFromTMDbToDomain() {
        let tmdbGenre = TMDb.Genre(id: 18, name: "Drama")

        let result = mapper.map(tmdbGenre)

        #expect(result.id == 18)
        #expect(result.name == "Drama")
    }

    @Test("Maps multiple genres correctly")
    func mapsMultipleGenres() {
        let tmdbGenres = [
            TMDb.Genre(id: 10765, name: "Sci-Fi & Fantasy"),
            TMDb.Genre(id: 18, name: "Drama"),
            TMDb.Genre(id: 10759, name: "Action & Adventure")
        ]

        let results = tmdbGenres.map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 10765)
        #expect(results[0].name == "Sci-Fi & Fantasy")
        #expect(results[1].id == 18)
        #expect(results[1].name == "Drama")
        #expect(results[2].id == 10759)
        #expect(results[2].name == "Action & Adventure")
    }

    @Test("Preserves genre properties exactly")
    func preservesGenreProperties() {
        let tmdbGenre = TMDb.Genre(id: 12345, name: "Test Genre With Special Characters !@#$%")

        let result = mapper.map(tmdbGenre)

        #expect(result.id == tmdbGenre.id)
        #expect(result.name == tmdbGenre.name)
    }

}
