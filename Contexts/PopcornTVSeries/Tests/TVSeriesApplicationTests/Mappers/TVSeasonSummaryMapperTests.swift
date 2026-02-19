//
//  TVSeasonSummaryMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TVSeriesApplication
import TVSeriesDomain

@Suite("TVSeasonSummaryMapper Tests")
struct TVSeasonSummaryMapperTests {

    private let imagesConfiguration: ImagesConfiguration
    private let mapper: TVSeasonSummaryMapper

    init() {
        self.imagesConfiguration = ImagesConfiguration.mock()
        self.mapper = TVSeasonSummaryMapper()
    }

    @Test("Maps TVSeason to TVSeasonSummary with resolved poster URL")
    func mapsWithResolvedPosterURL() throws {
        let posterPath = try #require(URL(string: "/fOaUnQwDJV22esXEswhaDMSqn2w.jpg"))
        let season = TVSeason.mock(
            id: 77680,
            name: "Season 1",
            seasonNumber: 1,
            posterPath: posterPath
        )

        let result = mapper.map(season, imagesConfiguration: imagesConfiguration)

        let expectedPosterURL = imagesConfiguration.posterURLSet(for: posterPath)?.detail
        #expect(result.id == 77680)
        #expect(result.name == "Season 1")
        #expect(result.seasonNumber == 1)
        #expect(result.posterURL == expectedPosterURL)
        #expect(result.posterURL != nil)
    }

    @Test("Maps TVSeason with nil posterPath to nil posterURL")
    func mapsWithNilPosterPathToNilPosterURL() {
        let season = TVSeason.mock(
            id: 77680,
            name: "Season 1",
            seasonNumber: 1,
            posterPath: nil
        )

        let result = mapper.map(season, imagesConfiguration: imagesConfiguration)

        #expect(result.posterURL == nil)
    }

    @Test("Preserves id, name, and seasonNumber")
    func preservesIdNameAndSeasonNumber() {
        let season = TVSeason.mock(
            id: 83248,
            name: "Stranger Things 2",
            seasonNumber: 2
        )

        let result = mapper.map(season, imagesConfiguration: imagesConfiguration)

        #expect(result.id == 83248)
        #expect(result.name == "Stranger Things 2")
        #expect(result.seasonNumber == 2)
    }

}
