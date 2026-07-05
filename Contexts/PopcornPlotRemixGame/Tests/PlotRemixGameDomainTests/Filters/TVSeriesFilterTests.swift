//
//  TVSeriesFilterTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

@testable import PlotRemixGameDomain
import Testing

@Suite("TVSeriesFilter")
struct TVSeriesFilterTests {

    @Test("init defaults originalLanguage and genres to nil")
    func initDefaultsOriginalLanguageAndGenresToNil() {
        let filter = TVSeriesFilter()

        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
    }

    @Test("init assigns all explicitly provided values")
    func initAssignsAllExplicitlyProvidedValues() {
        let filter = TVSeriesFilter(originalLanguage: "fr", genres: [18, 35])

        #expect(filter.originalLanguage == "fr")
        #expect(filter.genres == [18, 35])
    }

    @Test("equality holds for filters with identical values")
    func equalityHoldsForIdenticalValues() {
        let first = TVSeriesFilter(originalLanguage: "en", genres: [18])
        let second = TVSeriesFilter(originalLanguage: "en", genres: [18])

        #expect(first == second)
    }

    @Test("equality fails when originalLanguage differs")
    func equalityFailsWhenOriginalLanguageDiffers() {
        let first = TVSeriesFilter(originalLanguage: "en", genres: [18])
        let second = TVSeriesFilter(originalLanguage: "fr", genres: [18])

        #expect(first != second)
    }

    @Test("description includes all field labels and values")
    func descriptionIncludesAllFieldLabelsAndValues() {
        let filter = TVSeriesFilter(originalLanguage: "en", genres: [18])

        let description = filter.description

        #expect(description.hasPrefix("TVSeriesFilter("))
        #expect(description.contains("originalLanguage"))
        #expect(description.contains("en"))
        #expect(description.contains("genres"))
        #expect(description.contains("18"))
    }

    @Test("description reflects nil originalLanguage and genres")
    func descriptionReflectsNilValues() {
        let filter = TVSeriesFilter()

        #expect(filter.description.contains("nil"))
    }

}
