//
//  PrimaryReleaseYearFilterTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

@testable import PlotRemixGameDomain
import Testing

@Suite("PrimaryReleaseYearFilter")
struct PrimaryReleaseYearFilterTests {

    // MARK: - Same-Case Equality

    @Test("onYear is equal when the year matches")
    func onYearEqualWhenYearMatches() {
        #expect(PrimaryReleaseYearFilter.onYear(1999) == .onYear(1999))
    }

    @Test("onYear is not equal when the year differs")
    func onYearNotEqualWhenYearDiffers() {
        #expect(PrimaryReleaseYearFilter.onYear(1999) != .onYear(2000))
    }

    @Test("fromYear is equal when the year matches")
    func fromYearEqualWhenYearMatches() {
        #expect(PrimaryReleaseYearFilter.fromYear(2000) == .fromYear(2000))
    }

    @Test("fromYear is not equal when the year differs")
    func fromYearNotEqualWhenYearDiffers() {
        #expect(PrimaryReleaseYearFilter.fromYear(2000) != .fromYear(2001))
    }

    @Test("upToYear is equal when the year matches")
    func upToYearEqualWhenYearMatches() {
        #expect(PrimaryReleaseYearFilter.upToYear(2010) == .upToYear(2010))
    }

    @Test("upToYear is not equal when the year differs")
    func upToYearNotEqualWhenYearDiffers() {
        #expect(PrimaryReleaseYearFilter.upToYear(2010) != .upToYear(2011))
    }

    @Test("betweenYears is equal when both bounds match")
    func betweenYearsEqualWhenBothBoundsMatch() {
        let first = PrimaryReleaseYearFilter.betweenYears(start: 1980, end: 2025)
        let second = PrimaryReleaseYearFilter.betweenYears(start: 1980, end: 2025)

        #expect(first == second)
    }

    @Test("betweenYears is not equal when the start bound differs")
    func betweenYearsNotEqualWhenStartDiffers() {
        let first = PrimaryReleaseYearFilter.betweenYears(start: 1980, end: 2025)
        let second = PrimaryReleaseYearFilter.betweenYears(start: 1990, end: 2025)

        #expect(first != second)
    }

    @Test("betweenYears is not equal when the end bound differs")
    func betweenYearsNotEqualWhenEndDiffers() {
        let first = PrimaryReleaseYearFilter.betweenYears(start: 1980, end: 2025)
        let second = PrimaryReleaseYearFilter.betweenYears(start: 1980, end: 2020)

        #expect(first != second)
    }

    // MARK: - Cross-Case Equality

    @Test("different cases with the same year are never equal")
    func differentCasesAreNeverEqual() {
        let onYear = PrimaryReleaseYearFilter.onYear(2000)
        let fromYear = PrimaryReleaseYearFilter.fromYear(2000)
        let upToYear = PrimaryReleaseYearFilter.upToYear(2000)
        let betweenYears = PrimaryReleaseYearFilter.betweenYears(start: 2000, end: 2000)

        #expect(onYear != fromYear)
        #expect(onYear != upToYear)
        #expect(onYear != betweenYears)
        #expect(fromYear != upToYear)
        #expect(fromYear != betweenYears)
        #expect(upToYear != betweenYears)
    }

}
