//
//  TVSeasonMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
@testable import TVSeasonDetailsFeature
import TVSeriesApplication

@Suite("TVSeasonMapper")
struct TVSeasonMapperTests {

    let mapper = TVSeasonMapper()

    @Test("map maps all fields with poster URL set")
    func mapMapsAllFieldsWithPosterURLSet() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "/poster.jpg")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/poster.jpg")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w300/poster.jpg")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/original/poster.jpg")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/poster.jpg"))
        )

        let details = TVSeasonDetails(
            id: 3572,
            seasonNumber: 1,
            tvSeriesID: 1396,
            name: "Season 1",
            tvSeriesName: "Breaking Bad",
            posterURLSet: posterURLSet,
            overview: "The first season."
        )

        let result = mapper.map(details)

        #expect(result.id == 3572)
        #expect(result.seasonNumber == 1)
        #expect(result.tvSeriesID == 1396)
        #expect(result.name == "Season 1")
        #expect(result.tvSeriesName == "Breaking Bad")
        #expect(result.posterURL == posterURLSet.thumbnail)
        #expect(result.overview == "The first season.")
    }

    @Test("map handles nil poster URL set")
    func mapHandlesNilPosterURLSet() {
        let details = TVSeasonDetails(
            id: 3572,
            seasonNumber: 1,
            tvSeriesID: 1396,
            name: "Season 1",
            tvSeriesName: "Breaking Bad"
        )

        let result = mapper.map(details)

        #expect(result.id == 3572)
        #expect(result.seasonNumber == 1)
        #expect(result.tvSeriesID == 1396)
        #expect(result.name == "Season 1")
        #expect(result.tvSeriesName == "Breaking Bad")
        #expect(result.posterURL == nil)
        #expect(result.overview == nil)
    }

    @Test("map handles nil overview")
    func mapHandlesNilOverview() {
        let details = TVSeasonDetails(
            id: 3572,
            seasonNumber: 1,
            tvSeriesID: 1396,
            name: "Season 1",
            tvSeriesName: "Breaking Bad",
            overview: nil
        )

        let result = mapper.map(details)

        #expect(result.overview == nil)
    }

}
