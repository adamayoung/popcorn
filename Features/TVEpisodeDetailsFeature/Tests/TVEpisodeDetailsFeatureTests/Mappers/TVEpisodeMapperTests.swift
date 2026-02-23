//
//  TVEpisodeMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
@testable import TVEpisodeDetailsFeature
import TVSeriesApplication

@Suite("TVEpisodeMapper")
struct TVEpisodeMapperTests {

    let mapper = TVEpisodeMapper()

    @Test("map picks full URL from still URL set")
    func mapPicksFullURLFromStillURLSet() throws {
        let fullURL = try #require(URL(string: "https://example.com/full.jpg"))
        let cardURL = try #require(URL(string: "https://example.com/card.jpg"))
        let stillPath = try #require(URL(string: "/still.jpg"))
        let summary = TVEpisodeSummary(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "Overview",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            runtime: 58,
            stillURLSet: ImageURLSet(
                path: stillPath,
                thumbnail: cardURL,
                card: cardURL,
                detail: fullURL,
                full: fullURL
            )
        )

        let result = mapper.map(summary)

        #expect(result.stillURL == fullURL)
    }

    @Test("map returns nil still URL when URL set is nil")
    func mapReturnsNilStillURLWhenURLSetIsNil() {
        let summary = TVEpisodeSummary(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            stillURLSet: nil
        )

        let result = mapper.map(summary)

        #expect(result.stillURL == nil)
    }

    @Test("map maps all properties")
    func mapMapsAllProperties() {
        let airDate = Date(timeIntervalSince1970: 1_200_528_000)
        let summary = TVEpisodeSummary(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "Episode overview",
            airDate: airDate,
            runtime: 58,
            stillURLSet: nil
        )

        let result = mapper.map(summary)

        #expect(result.name == "Pilot")
        #expect(result.overview == "Episode overview")
        #expect(result.airDate == airDate)
    }

    @Test("map handles nil optionals")
    func mapHandlesNilOptionals() {
        let summary = TVEpisodeSummary(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1
        )

        let result = mapper.map(summary)

        #expect(result.overview == nil)
        #expect(result.airDate == nil)
        #expect(result.stillURL == nil)
    }

}
