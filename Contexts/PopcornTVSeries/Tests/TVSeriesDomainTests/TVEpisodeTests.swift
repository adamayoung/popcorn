//
//  TVEpisodeTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVSeriesDomain

@Suite("TVEpisode")
struct TVEpisodeTests {

    @Test("initialises with all properties")
    func initialisesWithAllProperties() throws {
        let airDate = Date(timeIntervalSince1970: 1_500_000_000)
        let stillPath = try #require(URL(string: "/still.jpg"))

        let episode = TVEpisode(
            id: 1,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "The first episode",
            airDate: airDate,
            runtime: 58,
            stillPath: stillPath
        )

        #expect(episode.id == 1)
        #expect(episode.name == "Pilot")
        #expect(episode.episodeNumber == 1)
        #expect(episode.seasonNumber == 1)
        #expect(episode.overview == "The first episode")
        #expect(episode.airDate == airDate)
        #expect(episode.runtime == 58)
        #expect(episode.stillPath == stillPath)
    }

    @Test("initialises with defaults for optional properties")
    func initialisesWithDefaultsForOptionalProperties() {
        let episode = TVEpisode(
            id: 2,
            name: "Second Episode",
            episodeNumber: 2,
            seasonNumber: 1
        )

        #expect(episode.id == 2)
        #expect(episode.name == "Second Episode")
        #expect(episode.episodeNumber == 2)
        #expect(episode.seasonNumber == 1)
        #expect(episode.overview == nil)
        #expect(episode.airDate == nil)
        #expect(episode.runtime == nil)
        #expect(episode.stillPath == nil)
    }

}
