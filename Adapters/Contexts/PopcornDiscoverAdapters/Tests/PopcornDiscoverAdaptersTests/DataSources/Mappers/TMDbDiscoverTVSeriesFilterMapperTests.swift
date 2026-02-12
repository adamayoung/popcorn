//
//  TMDbDiscoverTVSeriesFilterMapperTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
@testable import PopcornDiscoverAdapters
import Testing
import TMDb

@Suite("TMDbDiscoverTVSeriesFilterMapper Tests")
struct TMDbDiscoverTVSeriesFilterMapperTests {

    private let mapper = TMDbDiscoverTVSeriesFilterMapper()

    @Test("Returns nil when filter is nil")
    func returnsNilWhenFilterIsNil() {
        let result = mapper.compactMap(nil)

        #expect(result == nil)
    }

    @Test("Maps filter with all properties")
    func mapsFilterWithAllProperties() throws {
        let filter = TVSeriesFilter(
            originalLanguage: "en",
            genres: [18, 80, 9648]
        )

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == "en")
        #expect(result.genres == [18, 80, 9648])
    }

    @Test("Maps filter with only original language")
    func mapsFilterWithOnlyOriginalLanguage() throws {
        let filter = TVSeriesFilter(originalLanguage: "ko")

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == "ko")
        #expect(result.genres == nil)
    }

    @Test("Maps filter with only genres")
    func mapsFilterWithOnlyGenres() throws {
        let filter = TVSeriesFilter(genres: [10759, 10765])

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == nil)
        #expect(result.genres == [10759, 10765])
    }

    @Test("Maps filter with empty genres array")
    func mapsFilterWithEmptyGenresArray() throws {
        let filter = TVSeriesFilter(genres: [])

        let result = try #require(mapper.compactMap(filter))

        #expect(result.genres == [])
    }

    @Test("Maps filter with all nil properties")
    func mapsFilterWithAllNilProperties() throws {
        let filter = TVSeriesFilter()

        let result = try #require(mapper.compactMap(filter))

        #expect(result.originalLanguage == nil)
        #expect(result.genres == nil)
    }

}
