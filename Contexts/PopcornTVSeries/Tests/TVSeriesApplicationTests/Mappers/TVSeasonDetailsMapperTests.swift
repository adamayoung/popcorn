//
//  TVSeasonDetailsMapperTests.swift
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

@Suite("TVSeasonDetailsMapper")
struct TVSeasonDetailsMapperTests {

    let mapper = TVSeasonDetailsMapper()
    let imagesConfiguration = ImagesConfiguration.mock()

    @Test("map preserves all property values")
    func map_preservesAllPropertyValues() {
        let season = TVSeason.mock(
            id: 3572,
            name: "Season 1",
            seasonNumber: 1,
            overview: "The first season.",
            posterPath: URL(string: "/poster.jpg")
        )
        let tvSeries = TVSeries.mock(id: 1396, name: "Breaking Bad")

        let result = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.id == 3572)
        #expect(result.seasonNumber == 1)
        #expect(result.tvSeriesID == 1396)
        #expect(result.name == "Season 1")
        #expect(result.tvSeriesName == "Breaking Bad")
        #expect(result.overview == "The first season.")
    }

    @Test("map with poster path resolves poster URL set")
    func map_withPosterPath_resolvesPosterURLSet() {
        let season = TVSeason.mock(posterPath: URL(string: "/poster.jpg"))
        let tvSeries = TVSeries.mock()

        let result = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.posterURLSet != nil)
    }

    @Test("map with nil poster path returns nil poster URL set")
    func map_withNilPosterPath_returnsNilPosterURLSet() {
        let season = TVSeason.mock(posterPath: nil)
        let tvSeries = TVSeries.mock()

        let result = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.posterURLSet == nil)
    }

    @Test("map with nil overview preserves nil")
    func map_withNilOverview_preservesNil() {
        let season = TVSeason.mock(overview: nil)
        let tvSeries = TVSeries.mock()

        let result = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.overview == nil)
    }

    @Test("map includes episodes")
    func map_includesEpisodes() {
        let episodes = [
            TVEpisode.mock(id: 1, name: "Pilot", episodeNumber: 1),
            TVEpisode.mock(id: 2, name: "Cat's in the Bag...", episodeNumber: 2)
        ]
        let season = TVSeason.mock(episodes: episodes)
        let tvSeries = TVSeries.mock()

        let result = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.episodes.count == 2)
        #expect(result.episodes[0].id == 1)
        #expect(result.episodes[0].name == "Pilot")
        #expect(result.episodes[1].id == 2)
        #expect(result.episodes[1].name == "Cat's in the Bag...")
    }

    @Test("map returns empty episodes when season has none")
    func map_returnsEmptyEpisodesWhenNone() {
        let season = TVSeason.mock(episodes: [])
        let tvSeries = TVSeries.mock()

        let result = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.episodes.isEmpty)
    }

    @Test("map with poster path but handler returns nil URL set")
    func map_withPosterPathButHandlerReturnsNil() {
        let nilConfig = ImagesConfiguration.mock(
            posterURLHandler: { _, _ in nil }
        )
        let season = TVSeason.mock(posterPath: URL(string: "/poster.jpg"))
        let tvSeries = TVSeries.mock()

        let result = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: nilConfig
        )

        #expect(result.posterURLSet == nil)
    }

}
