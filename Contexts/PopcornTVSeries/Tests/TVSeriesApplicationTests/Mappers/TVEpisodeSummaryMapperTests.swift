//
//  TVEpisodeSummaryMapperTests.swift
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

@Suite("TVEpisodeSummaryMapper")
struct TVEpisodeSummaryMapperTests {

    let mapper = TVEpisodeSummaryMapper()
    let imagesConfiguration = ImagesConfiguration.mock()

    @Test("map episode with still path resolves still URL set")
    func mapEpisodeWithStillPath_resolvesStillURLSet() {
        let episode = TVEpisode.mock(stillPath: URL(string: "/still.jpg"))

        let result = mapper.map(episode, imagesConfiguration: imagesConfiguration)

        #expect(result.id == episode.id)
        #expect(result.name == episode.name)
        #expect(result.episodeNumber == episode.episodeNumber)
        #expect(result.seasonNumber == episode.seasonNumber)
        #expect(result.overview == episode.overview)
        #expect(result.airDate == episode.airDate)
        #expect(result.runtime == episode.runtime)
        #expect(result.stillURLSet != nil)
    }

    @Test("map episode with nil still path returns nil still URL set")
    func mapEpisodeWithNilStillPath_returnsNilStillURLSet() {
        let episode = TVEpisode.mock(stillPath: nil)

        let result = mapper.map(episode, imagesConfiguration: imagesConfiguration)

        #expect(result.stillURLSet == nil)
    }

    @Test("map episode with nil optionals preserves nil values")
    func mapEpisodeWithNilOptionals_preservesNilValues() {
        let episode = TVEpisode.mock(
            overview: nil,
            airDate: nil,
            runtime: nil,
            stillPath: nil
        )

        let result = mapper.map(episode, imagesConfiguration: imagesConfiguration)

        #expect(result.overview == nil)
        #expect(result.airDate == nil)
        #expect(result.runtime == nil)
        #expect(result.stillURLSet == nil)
    }

    @Test("map episode preserves all property values")
    func mapEpisode_preservesAllPropertyValues() {
        let airDate = Date(timeIntervalSince1970: 1_200_528_000)
        let episode = TVEpisode.mock(
            id: 99,
            name: "Test Episode",
            episodeNumber: 5,
            seasonNumber: 2,
            overview: "Test overview",
            airDate: airDate,
            runtime: 45,
            stillPath: URL(string: "/test.jpg")
        )

        let result = mapper.map(episode, imagesConfiguration: imagesConfiguration)

        #expect(result.id == 99)
        #expect(result.name == "Test Episode")
        #expect(result.episodeNumber == 5)
        #expect(result.seasonNumber == 2)
        #expect(result.overview == "Test overview")
        #expect(result.airDate == airDate)
        #expect(result.runtime == 45)
    }

    @Test("map episode with still path but handler returns nil URL set")
    func mapEpisodeWithStillPathButHandlerReturnsNil() {
        let nilConfig = ImagesConfiguration.mock(
            stillURLHandler: { _, _ in nil }
        )
        let episode = TVEpisode.mock(stillPath: URL(string: "/still.jpg"))

        let result = mapper.map(episode, imagesConfiguration: nilConfig)

        #expect(result.stillURLSet == nil)
    }

}
