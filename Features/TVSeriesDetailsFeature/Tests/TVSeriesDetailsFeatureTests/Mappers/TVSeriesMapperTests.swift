//
//  TVSeriesMapperTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesApplication
@testable import TVSeriesDetailsFeature
import TVSeriesDomain

@Suite("TVSeriesMapper Tests")
struct TVSeriesMapperTests {

    private let mapper = TVSeriesMapper()

    @Test("Maps TVSeriesDetails to TVSeries with all properties")
    func mapsTVSeriesDetailsWithAllProperties() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster-full.jpg"))
        )
        let backdropURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/backdrop-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/backdrop-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/backdrop-card.jpg")),
            detail: #require(URL(string: "https://example.com/backdrop-detail.jpg")),
            full: #require(URL(string: "https://example.com/backdrop-full.jpg"))
        )
        let logoURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/logo-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/logo-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/logo-card.jpg")),
            detail: #require(URL(string: "https://example.com/logo-detail.jpg")),
            full: #require(URL(string: "https://example.com/logo-full.jpg"))
        )

        let genres = [
            TVSeriesDomain.Genre(id: 18, name: "Drama"),
            TVSeriesDomain.Genre(id: 10759, name: "Action & Adventure")
        ]

        let details = TVSeriesDetails(
            id: 1399,
            name: "Game of Thrones",
            tagline: "Winter is Coming",
            overview: "A fantasy epic about noble houses fighting for control.",
            numberOfSeasons: 8,
            genres: genres,
            firstAirDate: Date(timeIntervalSince1970: 1_302_739_200),
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].id == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].id == 10759)
        #expect(result.genres?[1].name == "Action & Adventure")
        #expect(result.overview == "A fantasy epic about noble houses fighting for control.")
        #expect(result.posterURL == URL(string: "https://example.com/poster-detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/backdrop-full.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/logo-detail.jpg"))
    }

    @Test("Maps TVSeriesDetails with nil URL sets")
    func mapsTVSeriesDetailsWithNilURLSets() {
        let details = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Test overview",
            numberOfSeasons: 1
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.name == "Test Series")
        #expect(result.overview == "Test overview")
        #expect(result.posterURL == nil)
        #expect(result.backdropURL == nil)
        #expect(result.logoURL == nil)
    }

    @Test("Maps multiple TV series correctly")
    func mapsMultipleTVSeries() {
        let details1 = TVSeriesDetails(id: 1, name: "Series 1", overview: "Overview 1", numberOfSeasons: 1)
        let details2 = TVSeriesDetails(id: 2, name: "Series 2", overview: "Overview 2", numberOfSeasons: 2)

        let results = [details1, details2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].name == "Series 1")
        #expect(results[1].id == 2)
        #expect(results[1].name == "Series 2")
    }

    @Test("Maps TVSeriesDetails with seasons to TVSeries with TVSeasonPreview array")
    func mapsTVSeriesDetailsWithSeasons() throws {
        let posterURL1 = try #require(URL(string: "https://image.tmdb.org/t/p/w780/poster1.jpg"))
        let posterURL2 = try #require(URL(string: "https://image.tmdb.org/t/p/w780/poster2.jpg"))

        let details = TVSeriesDetails(
            id: 66732,
            name: "Stranger Things",
            overview: "Overview",
            numberOfSeasons: 2,
            seasons: [
                TVSeasonSummary(id: 77680, name: "Season 1", seasonNumber: 1, posterURL: posterURL1),
                TVSeasonSummary(id: 83248, name: "Stranger Things 2", seasonNumber: 2, posterURL: posterURL2)
            ]
        )

        let result = mapper.map(details)

        #expect(result.seasons.count == 2)
        #expect(result.seasons[0].id == 77680)
        #expect(result.seasons[0].name == "Season 1")
        #expect(result.seasons[0].seasonNumber == 1)
        #expect(result.seasons[0].posterURL == posterURL1)
        #expect(result.seasons[1].id == 83248)
        #expect(result.seasons[1].name == "Stranger Things 2")
        #expect(result.seasons[1].seasonNumber == 2)
    }

    @Test("Maps TVSeriesDetails with empty seasons to empty array")
    func mapsTVSeriesDetailsWithEmptySeasons() {
        let details = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Overview",
            numberOfSeasons: 0,
            seasons: []
        )

        let result = mapper.map(details)

        #expect(result.seasons.isEmpty)
    }

    @Test("Maps TVSeriesDetails with nil genres to nil")
    func mapsTVSeriesDetailsWithNilGenres() {
        let details = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Overview",
            numberOfSeasons: 1,
            genres: nil
        )

        let result = mapper.map(details)

        #expect(result.genres == nil)
    }

    @Test("Maps TVSeriesDetails with empty genres to empty array")
    func mapsTVSeriesDetailsWithEmptyGenres() {
        let details = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Overview",
            numberOfSeasons: 1,
            genres: []
        )

        let result = mapper.map(details)

        #expect(result.genres?.isEmpty == true)
    }

    @Test("Maps season posterURL correctly")
    func mapsSeasonPosterURLCorrectly() throws {
        let posterURL = try #require(URL(string: "https://image.tmdb.org/t/p/w780/poster.jpg"))

        let details = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Overview",
            numberOfSeasons: 1,
            seasons: [TVSeasonSummary(id: 1, name: "Season 1", seasonNumber: 1, posterURL: posterURL)]
        )

        let result = mapper.map(details)

        #expect(result.seasons[0].posterURL == posterURL)
    }

}
