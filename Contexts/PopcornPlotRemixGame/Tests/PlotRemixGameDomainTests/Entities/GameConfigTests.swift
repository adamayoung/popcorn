//
//  GameConfigTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

@testable import PlotRemixGameDomain
import Testing

@Suite("GameConfig")
struct GameConfigTests {

    @Test("init defaults genreID to nil when not provided")
    func initDefaultsGenreIDToNil() {
        let config = GameConfig(theme: .whimsical)

        #expect(config.genreID == nil)
    }

    @Test("init defaults primaryReleaseYearFilter to nil when not provided")
    func initDefaultsPrimaryReleaseYearFilterToNil() {
        let config = GameConfig(theme: .whimsical)

        #expect(config.primaryReleaseYearFilter == nil)
    }

    @Test("init assigns the provided theme")
    func initAssignsProvidedTheme() {
        let config = GameConfig(theme: .noir)

        #expect(config.theme == .noir)
    }

    @Test("init assigns an explicit genreID when provided")
    func initAssignsExplicitGenreID() {
        let config = GameConfig(theme: .whimsical, genreID: 28)

        #expect(config.genreID == 28)
    }

    @Test("init assigns an explicit primaryReleaseYearFilter when provided")
    func initAssignsExplicitPrimaryReleaseYearFilter() {
        let config = GameConfig(theme: .whimsical, primaryReleaseYearFilter: .onYear(1999))

        #expect(config.primaryReleaseYearFilter == .onYear(1999))
    }

}
