//
//  TMDbDiscoverMovieFilterMapperTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
@testable import PopcornDiscoverAdapters
import Testing
import TMDb

@Suite("TMDbDiscoverMovieFilterMapper Tests")
struct TMDbDiscoverMovieFilterMapperTests {

    private let mapper = TMDbDiscoverMovieFilterMapper()

    @Test("Returns nil when filter is nil")
    func returnsNilWhenFilterIsNil() {
        let result = mapper.compactMap(nil)

        #expect(result == nil)
    }

    @Test("Maps filter with all properties")
    func mapsFilterWithAllProperties() throws {
        let filter = MovieFilter(
            originalLanguage: "en",
            genres: [28, 12, 16],
            primaryReleaseYear: .onYear(2024)
        )

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == "en")
        #expect(result.genres == [28, 12, 16])
    }

    @Test("Maps filter with only original language")
    func mapsFilterWithOnlyOriginalLanguage() throws {
        let filter = MovieFilter(originalLanguage: "fr")

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == "fr")
        #expect(result.genres == nil)
    }

    @Test("Maps filter with only genres")
    func mapsFilterWithOnlyGenres() throws {
        let filter = MovieFilter(genres: [18, 35])

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == nil)
        #expect(result.genres == [18, 35])
    }

    @Test("Maps filter with empty genres array")
    func mapsFilterWithEmptyGenresArray() throws {
        let filter = MovieFilter(genres: [])

        let result = try #require(mapper.compactMap(filter))

        #expect(result.genres == [])
    }

    @Test("Maps primary release year filter onYear")
    func mapsPrimaryReleaseYearFilterOnYear() throws {
        let filter = MovieFilter(primaryReleaseYear: .onYear(2024))

        let result = try #require(mapper.compactMap(filter))

        #expect(result.primaryReleaseYear == .on(2024))
    }

    @Test("Maps primary release year filter fromYear")
    func mapsPrimaryReleaseYearFilterFromYear() throws {
        let filter = MovieFilter(primaryReleaseYear: .fromYear(2020))

        let result = try #require(mapper.compactMap(filter))

        #expect(result.primaryReleaseYear == .from(2020))
    }

    @Test("Maps primary release year filter upToYear")
    func mapsPrimaryReleaseYearFilterUpToYear() throws {
        let filter = MovieFilter(primaryReleaseYear: .upToYear(2019))

        let result = try #require(mapper.compactMap(filter))

        #expect(result.primaryReleaseYear == .upTo(2019))
    }

    @Test("Maps primary release year filter betweenYears")
    func mapsPrimaryReleaseYearFilterBetweenYears() throws {
        let filter = MovieFilter(primaryReleaseYear: .betweenYears(start: 2015, end: 2020))

        let result = try #require(mapper.compactMap(filter))

        #expect(result.primaryReleaseYear == .between(start: 2015, end: 2020))
    }

    @Test("Maps filter with nil primary release year")
    func mapsFilterWithNilPrimaryReleaseYear() throws {
        let filter = MovieFilter(
            originalLanguage: "en",
            genres: [28],
            primaryReleaseYear: nil
        )

        let result = try #require(mapper.compactMap(filter))

        #expect(result.primaryReleaseYear == nil)
    }

    @Test("Maps filter with all nil properties")
    func mapsFilterWithAllNilProperties() throws {
        let filter = MovieFilter()

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == nil)
        #expect(result.genres == nil)
        #expect(result.primaryReleaseYear == nil)
    }

}
