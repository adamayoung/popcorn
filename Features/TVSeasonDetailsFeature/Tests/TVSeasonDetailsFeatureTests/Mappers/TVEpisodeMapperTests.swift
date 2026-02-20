//
//  TVEpisodeMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
@testable import TVSeasonDetailsFeature
import TVSeriesApplication

@Suite("TVEpisodeMapper")
struct TVEpisodeMapperTests {

    let mapper = TVEpisodeMapper()

    @Test("map maps all fields with still URL set")
    func mapMapsAllFieldsWithStillURLSet() throws {
        let stillURLSet = try ImageURLSet(
            path: #require(URL(string: "/still.jpg")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/still.jpg")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w300/still.jpg")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/original/still.jpg")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/still.jpg"))
        )

        let summary = TVEpisodeSummary(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "A chemistry teacher begins cooking meth.",
            stillURLSet: stillURLSet
        )

        let result = mapper.map(summary)

        #expect(result.id == 62085)
        #expect(result.name == "Pilot")
        #expect(result.episodeNumber == 1)
        #expect(result.overview == "A chemistry teacher begins cooking meth.")
        #expect(result.stillURL == stillURLSet.card)
    }

    @Test("map handles nil still URL set")
    func mapHandlesNilStillURLSet() {
        let summary = TVEpisodeSummary(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1
        )

        let result = mapper.map(summary)

        #expect(result.id == 62085)
        #expect(result.name == "Pilot")
        #expect(result.episodeNumber == 1)
        #expect(result.overview == nil)
        #expect(result.stillURL == nil)
    }

    @Test("map handles nil overview")
    func mapHandlesNilOverview() {
        let summary = TVEpisodeSummary(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: nil
        )

        let result = mapper.map(summary)

        #expect(result.overview == nil)
    }

}
