//
//  TVSeriesMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("TVSeriesMapper Tests")
struct TVSeriesMapperTests {

    private let mapper = TVSeriesMapper()

    // MARK: - Breaking Bad Test Data (ID: 1396)

    @Test("Maps all properties from TMDb TV series to domain model using Breaking Bad")
    func mapsAllPropertiesUsingBreakingBad() throws {
        let posterPath = try #require(URL(string: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg"))
        let backdropPath = try #require(URL(string: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg"))
        let firstAirDate = Date(timeIntervalSince1970: 1_200_528_000) // 2008-01-20

        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            tagline: "All Hail the King",
            overview: "When Walter White, a chemistry teacher, is diagnosed with terminal cancer...",
            numberOfSeasons: 5,
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.id == 1396)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == "All Hail the King")
        #expect(result.overview == "When Walter White, a chemistry teacher, is diagnosed with terminal cancer...")
        #expect(result.numberOfSeasons == 5)
        #expect(result.firstAirDate == firstAirDate)
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("Maps with nil tagline")
    func mapsWithNilTagline() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            tagline: nil,
            overview: "A chemistry teacher diagnosed with terminal cancer..."
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.id == 1396)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == nil)
        #expect(result.overview == "A chemistry teacher diagnosed with terminal cancer...")
    }

    @Test("Maps nil overview to empty string")
    func mapsNilOverviewToEmptyString() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.id == 1396)
        #expect(result.overview == "")
    }

    @Test("Maps nil numberOfSeasons to zero")
    func mapsNilNumberOfSeasonsToZero() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            numberOfSeasons: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.numberOfSeasons == 0)
    }

    @Test("Maps with nil firstAirDate")
    func mapsWithNilFirstAirDate() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            firstAirDate: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.firstAirDate == nil)
    }

    @Test("Maps with nil posterPath")
    func mapsWithNilPosterPath() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            posterPath: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.posterPath == nil)
    }

    @Test("Maps with nil backdropPath")
    func mapsWithNilBackdropPath() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            backdropPath: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.backdropPath == nil)
    }

    @Test("Maps with all nil optional properties")
    func mapsWithAllNilOptionalProperties() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            tagline: nil,
            overview: nil,
            numberOfSeasons: nil,
            firstAirDate: nil,
            posterPath: nil,
            backdropPath: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.id == 1396)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == nil)
        #expect(result.overview == "")
        #expect(result.numberOfSeasons == 0)
        #expect(result.firstAirDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps empty overview string correctly")
    func mapsEmptyOverviewStringCorrectly() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: ""
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.overview == "")
    }

    @Test("Maps empty tagline string correctly")
    func mapsEmptyTaglineStringCorrectly() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            tagline: "",
            overview: "A chemistry teacher..."
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.tagline == "")
    }

    @Test("Preserves exact id value")
    func preservesExactIdValue() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 999_999,
            name: "Test Series",
            overview: "Test overview"
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.id == 999_999)
    }

    @Test("Preserves exact name value")
    func preservesExactNameValue() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad: Special Edition",
            overview: "Test overview"
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.name == "Breaking Bad: Special Edition")
    }

    @Test("Maps zero numberOfSeasons correctly")
    func mapsZeroNumberOfSeasonsCorrectly() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            numberOfSeasons: 0
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.numberOfSeasons == 0)
    }

    @Test("Maps large numberOfSeasons correctly")
    func mapsLargeNumberOfSeasonsCorrectly() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            numberOfSeasons: 35
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.numberOfSeasons == 35)
    }

    @Test("Maps seasons array from TMDb TV series")
    func mapsSeasonsArray() throws {
        let poster1 = try #require(URL(string: "/poster1.jpg"))
        let poster2 = try #require(URL(string: "/poster2.jpg"))

        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            seasons: [
                TMDb.TVSeason(id: 3572, name: "Season 1", seasonNumber: 1, posterPath: poster1),
                TMDb.TVSeason(id: 3573, name: "Season 2", seasonNumber: 2, posterPath: poster2)
            ]
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.seasons.count == 2)
        #expect(result.seasons[0].id == 3572)
        #expect(result.seasons[0].name == "Season 1")
        #expect(result.seasons[0].seasonNumber == 1)
        #expect(result.seasons[0].posterPath == poster1)
        #expect(result.seasons[1].id == 3573)
        #expect(result.seasons[1].seasonNumber == 2)
    }

    @Test("Maps nil seasons to empty array")
    func mapsNilSeasonsToEmptyArray() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            seasons: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.seasons.isEmpty)
    }

    @Test("Maps empty seasons array to empty array")
    func mapsEmptySeasonsArrayToEmptyArray() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            seasons: []
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.seasons.isEmpty)
    }

}
