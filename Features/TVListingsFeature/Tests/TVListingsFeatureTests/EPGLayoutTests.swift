//
//  EPGLayoutTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreGraphics
import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsFeature

@Suite("EPGLayout")
struct EPGLayoutTests {

    // MARK: - isNarrow

    @Test
    func isNarrowReturnsTrueBelowThreshold() {
        #expect(EPGLayout.isNarrow(width: 50, threshold: 80))
    }

    @Test
    func isNarrowReturnsFalseAtThreshold() {
        #expect(!EPGLayout.isNarrow(width: 80, threshold: 80))
    }

    @Test
    func isNarrowReturnsFalseAboveThreshold() {
        #expect(!EPGLayout.isNarrow(width: 120, threshold: 80))
    }

    @Test
    func isNarrowUsesDefaultThreshold() {
        #expect(EPGLayout.isNarrow(width: 79))
        #expect(!EPGLayout.isNarrow(width: 81))
    }

    // MARK: - blockWidth

    @Test
    func blockWidthKeepsRawWidthForLastProgramme() {
        // No next programme → full raw width is kept.
        #expect(EPGLayout.blockWidth(rawWidth: 44, startX: 0, nextStartX: nil) == 44)
    }

    @Test
    func blockWidthKeepsRawWidthWhenItFitsBeforeNext() {
        // Next starts at 100, raw width 60 fits → unchanged.
        #expect(EPGLayout.blockWidth(rawWidth: 60, startX: 0, nextStartX: 100) == 60)
    }

    @Test
    func blockWidthClampsToNextStartToPreventOverlap() {
        // A 5-min block floored to minBlockWidth (44) but the next starts only
        // 15pt later → clamp to 15 so it can't overlap the neighbour.
        #expect(EPGLayout.blockWidth(rawWidth: 44, startX: 0, nextStartX: 15) == 15)
    }

    @Test
    func blockWidthNeverGoesBelowOne() {
        // Degenerate/overlapping data (next at or before start) → at least 1.
        #expect(EPGLayout.blockWidth(rawWidth: 44, startX: 30, nextStartX: 30) == 1)
        #expect(EPGLayout.blockWidth(rawWidth: 44, startX: 30, nextStartX: 10) == 1)
    }

    // MARK: - visibleProgrammes

    private static func item(start: TimeInterval, end: TimeInterval, id: String) -> TVListingsProgrammeItem {
        let programme = TVProgramme(
            id: id,
            channelID: "C",
            title: id,
            description: "",
            startTime: Date(timeIntervalSince1970: start),
            endTime: Date(timeIntervalSince1970: end),
            duration: end - start,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )
        return TVListingsProgrammeItem(programme: programme, isAiringNow: false, genre: nil, progress: 0)
    }

    private static let programmes: [TVListingsProgrammeItem] = [
        item(start: 0, end: 100, id: "a"),
        item(start: 100, end: 200, id: "b"),
        item(start: 200, end: 300, id: "c"),
        item(start: 300, end: 400, id: "d")
    ]

    @Test
    func visibleProgrammesIncludesOnlyIntersectingBlocks() {
        let range = Date(timeIntervalSince1970: 110) ... Date(timeIntervalSince1970: 190)
        let result = EPGLayout.visibleProgrammes(in: Self.programmes, range: range)
        #expect(result.map(\.id) == ["b"])
    }

    @Test
    func visibleProgrammesIncludesPartiallyOverlappingBlocks() {
        let range = Date(timeIntervalSince1970: 90) ... Date(timeIntervalSince1970: 210)
        let result = EPGLayout.visibleProgrammes(in: Self.programmes, range: range)
        #expect(result.map(\.id) == ["a", "b", "c"])
    }

    @Test
    func visibleProgrammesExcludesBlockEndingExactlyAtLowerBound() {
        // Block "a" ends at 100; a range starting at 100 should not include it
        // (endTime > lower is strict).
        let range = Date(timeIntervalSince1970: 100) ... Date(timeIntervalSince1970: 150)
        let result = EPGLayout.visibleProgrammes(in: Self.programmes, range: range)
        #expect(result.map(\.id) == ["b"])
    }

    @Test
    func visibleProgrammesExcludesBlockStartingExactlyAtUpperBound() {
        // Block "c" starts at 200; a range ending at 200 should not include it.
        let range = Date(timeIntervalSince1970: 110) ... Date(timeIntervalSince1970: 200)
        let result = EPGLayout.visibleProgrammes(in: Self.programmes, range: range)
        #expect(result.map(\.id) == ["b"])
    }

    @Test
    func visibleProgrammesOverscanWidensTheWindow() {
        let range = Date(timeIntervalSince1970: 110) ... Date(timeIntervalSince1970: 190)
        let result = EPGLayout.visibleProgrammes(in: Self.programmes, range: range, overscan: 50)
        // Overscan ±50 widens to 60...240, pulling in "a" and "c".
        #expect(result.map(\.id) == ["a", "b", "c"])
    }

    @Test
    func visibleProgrammesReturnsEmptyForNoProgrammes() {
        let range = Date(timeIntervalSince1970: 0) ... Date(timeIntervalSince1970: 400)
        let result = EPGLayout.visibleProgrammes(in: [], range: range)
        #expect(result.isEmpty)
    }

}
