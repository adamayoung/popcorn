//
//  MovieFilterTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

@testable import PlotRemixGameDomain
import Testing

@Suite("MovieFilter")
struct MovieFilterTests {

    // MARK: - Direct init

    @Test("init defaults originalLanguage and genres to nil")
    func initDefaultsOriginalLanguageAndGenresToNil() {
        let filter = MovieFilter(primaryReleaseYear: .betweenYears(start: 1980, end: 2025))

        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
    }

    @Test("init assigns all explicitly provided values")
    func initAssignsAllExplicitlyProvidedValues() {
        let filter = MovieFilter(
            originalLanguage: "fr",
            genres: [28, 18],
            primaryReleaseYear: .fromYear(2000)
        )

        #expect(filter.originalLanguage == "fr")
        #expect(filter.genres == [28, 18])
        #expect(filter.primaryReleaseYear == .fromYear(2000))
    }

    @Test("equality holds for filters with identical values")
    func equalityHoldsForIdenticalValues() {
        let first = MovieFilter(originalLanguage: "en", genres: [28], primaryReleaseYear: .onYear(1999))
        let second = MovieFilter(originalLanguage: "en", genres: [28], primaryReleaseYear: .onYear(1999))

        #expect(first == second)
    }

    @Test("equality fails when genres differ")
    func equalityFailsWhenGenresDiffer() {
        let first = MovieFilter(originalLanguage: "en", genres: [28], primaryReleaseYear: .onYear(1999))
        let second = MovieFilter(originalLanguage: "en", genres: [12], primaryReleaseYear: .onYear(1999))

        #expect(first != second)
    }

    // MARK: - description

    @Test("description includes all field labels and values")
    func descriptionIncludesAllFieldLabelsAndValues() {
        let filter = MovieFilter(
            originalLanguage: "en",
            genres: [28],
            primaryReleaseYear: .betweenYears(start: 1980, end: 2025)
        )

        let description = filter.description

        #expect(description.hasPrefix("MovieFilter("))
        #expect(description.contains("originalLanguage"))
        #expect(description.contains("en"))
        #expect(description.contains("genres"))
        #expect(description.contains("28"))
        #expect(description.contains("primaryReleaseYear"))
        #expect(description.contains("betweenYears"))
        #expect(description.contains("1980"))
        #expect(description.contains("2025"))
    }

    @Test("description reflects nil originalLanguage and genres")
    func descriptionReflectsNilValues() {
        let filter = MovieFilter(primaryReleaseYear: .onYear(2000))

        #expect(filter.description.contains("nil"))
    }

    // MARK: - init(config:)

    @Test("init(config:) sets originalLanguage to en")
    func configInitSetsOriginalLanguageToEnglish() {
        let config = GameConfig(theme: .whimsical)

        let filter = MovieFilter(config: config)

        #expect(filter.originalLanguage == "en")
    }

    @Test("init(config:) sets genres to nil when config has no genreID")
    func configInitSetsGenresToNilWhenNoGenreID() {
        let config = GameConfig(theme: .whimsical, genreID: nil)

        let filter = MovieFilter(config: config)

        #expect(filter.genres == nil)
    }

    @Test("init(config:) maps a genreID to a single-element genres array")
    func configInitMapsGenreIDToSingleElementArray() {
        let config = GameConfig(theme: .whimsical, genreID: 28)

        let filter = MovieFilter(config: config)

        #expect(filter.genres == [28])
    }

    @Test("init(config:) defaults primaryReleaseYear to 1980 through 2025 when not provided")
    func configInitDefaultsPrimaryReleaseYear() {
        let config = GameConfig(theme: .whimsical, primaryReleaseYearFilter: nil)

        let filter = MovieFilter(config: config)

        #expect(filter.primaryReleaseYear == .betweenYears(start: 1980, end: 2025))
    }

    @Test("init(config:) uses the provided primaryReleaseYearFilter when set")
    func configInitUsesProvidedPrimaryReleaseYearFilter() {
        let config = GameConfig(theme: .whimsical, primaryReleaseYearFilter: .onYear(1999))

        let filter = MovieFilter(config: config)

        #expect(filter.primaryReleaseYear == .onYear(1999))
    }

}
