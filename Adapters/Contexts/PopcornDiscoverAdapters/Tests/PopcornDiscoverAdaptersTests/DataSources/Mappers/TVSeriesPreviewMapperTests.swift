//
//  TVSeriesPreviewMapperTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation
@testable import PopcornDiscoverAdapters
import Testing
import TMDb

@Suite("TVSeriesPreviewMapper Tests")
struct TVSeriesPreviewMapperTests {

    private let mapper = TVSeriesPreviewMapper()

    @Test("Maps all properties from TMDb TVSeriesListItem to DiscoverDomain TVSeriesPreview")
    func mapsAllProperties() throws {
        let posterPath = try #require(URL(string: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"))
        let backdropPath = try #require(URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"))
        let firstAirDate = Date(timeIntervalSince1970: 1_200_528_000)

        let tmdbTVSeriesListItem = TVSeriesListItem(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "A high school chemistry teacher diagnosed with inoperable lung cancer...",
            genreIDs: [18, 80],
            firstAirDate: firstAirDate,
            originCountries: ["US"],
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 400.5,
            voteAverage: 9.5,
            voteCount: 15000,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbTVSeriesListItem)

        #expect(result.id == 1396)
        #expect(result.name == "Breaking Bad")
        #expect(
            result.overview
                == "A high school chemistry teacher diagnosed with inoperable lung cancer..."
        )
        #expect(result.firstAirDate == firstAirDate)
        #expect(result.genreIDs == [18, 80])
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("Maps with nil first air date uses current date")
    func mapsWithNilFirstAirDateUsesCurrentDate() {
        let tmdbTVSeriesListItem = TVSeriesListItem(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "A TV series overview",
            genreIDs: [18],
            firstAirDate: nil,
            originCountries: ["US"],
            posterPath: nil,
            backdropPath: nil,
            popularity: 100.0,
            voteAverage: 9.0,
            voteCount: 5000,
            isAdultOnly: false
        )

        let beforeMapping = Date()
        let result = mapper.map(tmdbTVSeriesListItem)
        let afterMapping = Date()

        #expect(result.firstAirDate >= beforeMapping)
        #expect(result.firstAirDate <= afterMapping)
    }

    @Test("Maps with nil optional path properties")
    func mapsWithNilOptionalPathProperties() {
        let firstAirDate = Date(timeIntervalSince1970: 1_200_528_000)

        let tmdbTVSeriesListItem = TVSeriesListItem(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "A TV series overview",
            genreIDs: [18, 80],
            firstAirDate: firstAirDate,
            originCountries: ["US"],
            posterPath: nil,
            backdropPath: nil,
            popularity: 100.0,
            voteAverage: 9.0,
            voteCount: 5000,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbTVSeriesListItem)

        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps with empty genre IDs array")
    func mapsWithEmptyGenreIDsArray() {
        let tmdbTVSeriesListItem = TVSeriesListItem(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "A TV series overview",
            genreIDs: [],
            firstAirDate: Date(),
            originCountries: ["US"],
            posterPath: nil,
            backdropPath: nil,
            popularity: 100.0,
            voteAverage: 9.0,
            voteCount: 5000,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbTVSeriesListItem)

        #expect(result.genreIDs.isEmpty)
    }

    @Test("Maps empty overview correctly")
    func mapsEmptyOverviewCorrectly() {
        let tmdbTVSeriesListItem = TVSeriesListItem(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "",
            genreIDs: [18],
            firstAirDate: Date(),
            originCountries: ["US"],
            posterPath: nil,
            backdropPath: nil,
            popularity: 100.0,
            voteAverage: 9.0,
            voteCount: 5000,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbTVSeriesListItem)

        #expect(result.overview == "")
    }

}
