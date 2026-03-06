//
//  TVEpisodeDetailsMapperTests.swift
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

@Suite("TVEpisodeDetailsMapper")
struct TVEpisodeDetailsMapperTests {

    let mapper = TVEpisodeDetailsMapper()
    let imagesConfiguration = ImagesConfiguration.mock()

    @Test("map preserves all property values")
    func map_preservesAllPropertyValues() {
        let airDate = Date(timeIntervalSince1970: 1_200_528_000)
        let episode = TVEpisode.mock(
            id: 99,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "Episode overview",
            airDate: airDate,
            runtime: 58,
            stillPath: URL(string: "/still.jpg")
        )
        let season = TVSeason.mock(id: 3572, name: "Season 1")
        let series = TVSeries.mock(id: 1396, name: "Breaking Bad")

        let result = mapper.map(
            episode,
            season: season,
            series: series,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.id == 99)
        #expect(result.name == "Pilot")
        #expect(result.episodeNumber == 1)
        #expect(result.seasonNumber == 1)
        #expect(result.tvSeasonID == 3572)
        #expect(result.tvSeriesID == 1396)
        #expect(result.tvSeasonName == "Season 1")
        #expect(result.tvSeriesName == "Breaking Bad")
        #expect(result.overview == "Episode overview")
        #expect(result.airDate == airDate)
        #expect(result.runtime == 58)
    }

    @Test("map with still path resolves still URL set")
    func map_withStillPath_resolvesStillURLSet() {
        let episode = TVEpisode.mock(stillPath: URL(string: "/still.jpg"))
        let season = TVSeason.mock()
        let series = TVSeries.mock()

        let result = mapper.map(
            episode,
            season: season,
            series: series,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.stillURLSet != nil)
    }

    @Test("map with nil still path returns nil still URL set")
    func map_withNilStillPath_returnsNilStillURLSet() {
        let episode = TVEpisode.mock(stillPath: nil)
        let season = TVSeason.mock()
        let series = TVSeries.mock()

        let result = mapper.map(
            episode,
            season: season,
            series: series,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.stillURLSet == nil)
    }

    @Test("map with nil optionals preserves nil values")
    func map_withNilOptionals_preservesNilValues() {
        let episode = TVEpisode.mock(
            overview: nil,
            airDate: nil,
            runtime: nil,
            stillPath: nil
        )
        let season = TVSeason.mock()
        let series = TVSeries.mock()

        let result = mapper.map(
            episode,
            season: season,
            series: series,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.overview == nil)
        #expect(result.airDate == nil)
        #expect(result.runtime == nil)
        #expect(result.stillURLSet == nil)
    }

    @Test("map with still path but handler returns nil URL set")
    func map_withStillPathButHandlerReturnsNil() {
        let nilConfig = ImagesConfiguration.mock(
            stillURLHandler: { _, _ in nil }
        )
        let episode = TVEpisode.mock(stillPath: URL(string: "/still.jpg"))
        let season = TVSeason.mock()
        let series = TVSeries.mock()

        let result = mapper.map(
            episode,
            season: season,
            series: series,
            imagesConfiguration: nilConfig
        )

        #expect(result.stillURLSet == nil)
    }

}
