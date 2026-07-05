//
//  GameThemeTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

@testable import PlotRemixGameDomain
import Testing

@Suite("GameTheme")
struct GameThemeTests {

    @Test("allCases contains exactly the twelve documented themes")
    func allCasesContainsTwelveThemes() {
        #expect(GameTheme.allCases.count == 12)
    }

    @Test("allCases contains each documented theme")
    func allCasesContainsEachDocumentedTheme() {
        let expectedThemes: [GameTheme] = [
            .darkCryptic, .whimsical, .noir, .mythic, .fairyTale, .sciFiOracle,
            .humorous, .poetic, .legalese, .child, .pirate, .minimalist
        ]

        for theme in expectedThemes {
            #expect(GameTheme.allCases.contains(theme))
        }
    }

    @Test("equality holds for the same case")
    func equalityHoldsForSameCase() {
        #expect(GameTheme.noir == GameTheme.noir)
    }

    @Test("equality fails for different cases")
    func equalityFailsForDifferentCases() {
        #expect(GameTheme.noir != GameTheme.whimsical)
    }

}
