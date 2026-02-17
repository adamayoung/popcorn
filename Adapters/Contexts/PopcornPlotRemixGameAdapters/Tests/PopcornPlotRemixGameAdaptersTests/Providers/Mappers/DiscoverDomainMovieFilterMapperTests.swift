//
//  DiscoverDomainMovieFilterMapperTests.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation
import PlotRemixGameDomain
@testable import PopcornPlotRemixGameAdapters
import Testing

@Suite("DiscoverDomainMovieFilterMapper Tests")
struct DiscoverDomainMovieFilterMapperTests {

    private let mapper = DiscoverDomainMovieFilterMapper()

    // MARK: - Basic Property Mapping Tests

    @Test("Maps filter with original language")
    func mapsFilterWithOriginalLanguage() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .betweenYears(start: 1990, end: 2020)
        )

        let result = mapper.map(source)

        #expect(result.originalLanguage == "en")
    }

    @Test("Maps filter with nil original language")
    func mapsFilterWithNilOriginalLanguage() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: nil,
            genres: nil,
            primaryReleaseYear: .betweenYears(start: 1990, end: 2020)
        )

        let result = mapper.map(source)

        #expect(result.originalLanguage == nil)
    }

    @Test("Maps filter with single genre")
    func mapsFilterWithSingleGenre() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: [28],
            primaryReleaseYear: .betweenYears(start: 1990, end: 2020)
        )

        let result = mapper.map(source)

        #expect(result.genres == [28])
    }

    @Test("Maps filter with multiple genres")
    func mapsFilterWithMultipleGenres() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: [28, 18, 53],
            primaryReleaseYear: .betweenYears(start: 1990, end: 2020)
        )

        let result = mapper.map(source)

        #expect(result.genres == [28, 18, 53])
    }

    @Test("Maps filter with nil genres")
    func mapsFilterWithNilGenres() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .betweenYears(start: 1990, end: 2020)
        )

        let result = mapper.map(source)

        #expect(result.genres == nil)
    }

    @Test("Maps filter with empty genres array")
    func mapsFilterWithEmptyGenresArray() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: [],
            primaryReleaseYear: .betweenYears(start: 1990, end: 2020)
        )

        let result = mapper.map(source)

        #expect(result.genres == [])
    }

    // MARK: - Primary Release Year Filter Mapping Tests

    @Test("Maps onYear filter correctly")
    func mapsOnYearFilter() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .onYear(2020)
        )

        let result = mapper.map(source)

        #expect(result.primaryReleaseYear == .onYear(2020))
    }

    @Test("Maps fromYear filter correctly")
    func mapsFromYearFilter() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .fromYear(1990)
        )

        let result = mapper.map(source)

        #expect(result.primaryReleaseYear == .fromYear(1990))
    }

    @Test("Maps upToYear filter correctly")
    func mapsUpToYearFilter() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .upToYear(2010)
        )

        let result = mapper.map(source)

        #expect(result.primaryReleaseYear == .upToYear(2010))
    }

    @Test("Maps betweenYears filter correctly")
    func mapsBetweenYearsFilter() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )

        let result = mapper.map(source)

        #expect(result.primaryReleaseYear == .betweenYears(start: 1980, end: 2025))
    }

    // MARK: - Complete Filter Mapping Tests

    @Test("Maps complete filter with all properties")
    func mapsCompleteFilterWithAllProperties() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "fr",
            genres: [12, 16],
            primaryReleaseYear: .fromYear(2000)
        )

        let result = mapper.map(source)

        #expect(result.originalLanguage == "fr")
        #expect(result.genres == [12, 16])
        #expect(result.primaryReleaseYear == .fromYear(2000))
    }

    @Test("Maps filter with different language codes")
    func mapsFilterWithDifferentLanguageCodes() {
        let languages = ["en", "fr", "es", "de", "ja", "ko", "zh"]

        for language in languages {
            let source = PlotRemixGameDomain.MovieFilter(
                originalLanguage: language,
                genres: nil,
                primaryReleaseYear: .betweenYears(start: 1990, end: 2020)
            )

            let result = mapper.map(source)

            #expect(result.originalLanguage == language)
        }
    }

    @Test("Maps filter with edge year values")
    func mapsFilterWithEdgeYearValues() {
        let source = PlotRemixGameDomain.MovieFilter(
            originalLanguage: "en",
            genres: nil,
            primaryReleaseYear: .betweenYears(start: 1900, end: 2100)
        )

        let result = mapper.map(source)

        #expect(result.primaryReleaseYear == .betweenYears(start: 1900, end: 2100))
    }

}
