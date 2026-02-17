//
//  TVSeriesPreviewMapperTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TMDb
import TrendingDomain

@Suite("TVSeriesPreviewMapper Tests")
struct TVSeriesPreviewMapperTests {

    private let mapper = TVSeriesPreviewMapper()

    @Test("Maps all properties from TMDb TVSeriesListItem to TVSeriesPreview")
    func mapsAllProperties() throws {
        let posterPath = try #require(URL(string: "https://example.com/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://example.com/backdrop.jpg"))

        let tmdbTVSeries = TVSeriesListItem(
            id: 1399,
            name: "Game of Thrones",
            originalName: "Game of Thrones",
            originalLanguage: "en",
            overview: "Seven noble families fight for control of the mythical land of Westeros.",
            genreIDs: [10765, 18, 10759],
            firstAirDate: Date(timeIntervalSince1970: 1_303_171_200),
            originCountries: ["US"],
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 369.594,
            voteAverage: 8.4,
            voteCount: 21755,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(
            result.overview
                == "Seven noble families fight for control of the mythical land of Westeros."
        )
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let tmdbTVSeries = TVSeriesListItem(
            id: 1399,
            name: "Game of Thrones",
            originalName: "Game of Thrones",
            originalLanguage: "en",
            overview: "A fantasy TV series.",
            genreIDs: [],
            firstAirDate: nil,
            originCountries: [],
            posterPath: nil,
            backdropPath: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(result.overview == "A fantasy TV series.")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps empty overview string")
    func mapsEmptyOverviewString() {
        let tmdbTVSeries = TVSeriesListItem(
            id: 1399,
            name: "Game of Thrones",
            originalName: "Game of Thrones",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            firstAirDate: nil,
            originCountries: [],
            posterPath: nil,
            backdropPath: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.overview == "")
    }

    @Test("Maps poster path only when provided")
    func mapsPosterPathOnlyWhenProvided() throws {
        let posterPath = try #require(URL(string: "https://example.com/poster.jpg"))

        let tmdbTVSeries = TVSeriesListItem(
            id: 123,
            name: "Test Series",
            originalName: "Test Series",
            originalLanguage: "en",
            overview: "Test overview",
            genreIDs: [],
            firstAirDate: nil,
            originCountries: [],
            posterPath: posterPath,
            backdropPath: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps backdrop path only when provided")
    func mapsBackdropPathOnlyWhenProvided() throws {
        let backdropPath = try #require(URL(string: "https://example.com/backdrop.jpg"))

        let tmdbTVSeries = TVSeriesListItem(
            id: 123,
            name: "Test Series",
            originalName: "Test Series",
            originalLanguage: "en",
            overview: "Test overview",
            genreIDs: [],
            firstAirDate: nil,
            originCountries: [],
            posterPath: nil,
            backdropPath: backdropPath
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.posterPath == nil)
        #expect(result.backdropPath == backdropPath)
    }

}
