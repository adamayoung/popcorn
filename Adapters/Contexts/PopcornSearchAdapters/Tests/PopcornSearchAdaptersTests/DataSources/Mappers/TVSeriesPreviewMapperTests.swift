//
//  TVSeriesPreviewMapperTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import PopcornSearchAdapters
import SearchDomain
import Testing
import TMDb

@Suite("TVSeriesPreviewMapper Tests")
struct TVSeriesPreviewMapperTests {

    @Test("map converts TMDb TVSeriesListItem to TVSeriesPreview with all fields")
    func mapConvertsTMDbTVSeriesListItemToTVSeriesPreviewWithAllFields() throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))
        let tvSeriesListItem = TVSeriesListItem(
            id: 789,
            name: "Test TV Series",
            originalName: "Test TV Series Original",
            originalLanguage: "en",
            overview: "A test TV series overview",
            genreIDs: [18, 10765],
            firstAirDate: Date(timeIntervalSince1970: 1_500_000_000),
            originCountries: ["US"],
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 200.3,
            voteAverage: 9.0,
            voteCount: 2000,
            isAdultOnly: false
        )

        let mapper = TVSeriesPreviewMapper()
        let result = mapper.map(tvSeriesListItem)

        #expect(result.id == 789)
        #expect(result.name == "Test TV Series")
        #expect(result.overview == "A test TV series overview")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("map converts TMDb TVSeriesListItem with nil optional fields")
    func mapConvertsTMDbTVSeriesListItemWithNilOptionalFields() {
        let tvSeriesListItem = TVSeriesListItem(
            id: 101,
            name: "Minimal TV Series",
            originalName: "Minimal TV Series",
            originalLanguage: "en",
            overview: "A minimal TV series",
            genreIDs: [],
            firstAirDate: nil,
            originCountries: [],
            posterPath: nil,
            backdropPath: nil
        )

        let mapper = TVSeriesPreviewMapper()
        let result = mapper.map(tvSeriesListItem)

        #expect(result.id == 101)
        #expect(result.name == "Minimal TV Series")
        #expect(result.overview == "A minimal TV series")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

}
