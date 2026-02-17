//
//  TVSeriesMapperTests.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
@testable import PopcornIntelligenceAdapters
import Testing
import TVSeriesApplication

@Suite("TVSeriesMapper Tests")
struct TVSeriesMapperTests {

    private let mapper = TVSeriesMapper()

    @Test("Maps all properties from TVSeriesDetails to IntelligenceDomain TVSeries")
    func mapsAllProperties() throws {
        let posterURLSet = try makeImageURLSet(path: "poster.jpg")
        let backdropURLSet = try makeImageURLSet(path: "backdrop.jpg")

        let tvSeriesDetails = TVSeriesDetails(
            id: 1396,
            name: "Breaking Bad",
            tagline: "All Hail the King",
            overview: "A high school chemistry teacher diagnosed with terminal lung cancer...",
            numberOfSeasons: 5,
            firstAirDate: Date(timeIntervalSince1970: 1_200_614_400),
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )

        let result = mapper.map(tvSeriesDetails)

        #expect(result.id == 1396)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == "All Hail the King")
        #expect(result.overview == "A high school chemistry teacher diagnosed with terminal lung cancer...")
        #expect(result.numberOfSeasons == 5)
        #expect(result.posterPath == posterURLSet.path)
        #expect(result.backdropPath == backdropURLSet.path)
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let tvSeriesDetails = TVSeriesDetails(
            id: 1396,
            name: "Breaking Bad",
            tagline: nil,
            overview: "An overview",
            numberOfSeasons: 5,
            firstAirDate: nil,
            posterURLSet: nil,
            backdropURLSet: nil
        )

        let result = mapper.map(tvSeriesDetails)

        #expect(result.id == 1396)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == nil)
        #expect(result.overview == "An overview")
        #expect(result.numberOfSeasons == 5)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps poster path correctly from URLSet")
    func mapsPosterPathFromURLSet() throws {
        let posterURLSet = try makeImageURLSet(path: "custom_poster.jpg")

        let tvSeriesDetails = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Test overview",
            numberOfSeasons: 3,
            posterURLSet: posterURLSet
        )

        let result = mapper.map(tvSeriesDetails)

        #expect(result.posterPath == posterURLSet.path)
    }

    @Test("Maps backdrop path correctly from URLSet")
    func mapsBackdropPathFromURLSet() throws {
        let backdropURLSet = try makeImageURLSet(path: "custom_backdrop.jpg")

        let tvSeriesDetails = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Test overview",
            numberOfSeasons: 3,
            backdropURLSet: backdropURLSet
        )

        let result = mapper.map(tvSeriesDetails)

        #expect(result.backdropPath == backdropURLSet.path)
    }

    @Test("Handles empty overview string")
    func handlesEmptyOverviewString() {
        let tvSeriesDetails = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "",
            numberOfSeasons: 1
        )

        let result = mapper.map(tvSeriesDetails)

        #expect(result.overview == "")
    }

    @Test("Maps zero seasons correctly")
    func mapsZeroSeasonsCorrectly() {
        let tvSeriesDetails = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Test overview",
            numberOfSeasons: 0
        )

        let result = mapper.map(tvSeriesDetails)

        #expect(result.numberOfSeasons == 0)
    }

}

// MARK: - Test Helpers

extension TVSeriesMapperTests {

    private func makeImageURLSet(path: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/\(path)")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w342/\(path)")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/w500/\(path)")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)"))
        )
    }

}
