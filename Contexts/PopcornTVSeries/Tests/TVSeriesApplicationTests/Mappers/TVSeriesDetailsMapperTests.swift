//
//  TVSeriesDetailsMapperTests.swift
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

@Suite("TVSeriesDetailsMapperTests")
struct TVSeriesDetailsMapperTests {

    let imagesConfiguration: ImagesConfiguration

    init() {
        self.imagesConfiguration = ImagesConfiguration.mock()
    }

    @Test("map should return TV series details")
    func map_shouldReturnTVSeriesDetails() {
        let tvSeries = TVSeries.mock(
            id: 303,
            name: "The Bear",
            overview: "Carmen returns to Chicago to run the family sandwich shop.",
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )
        let imageCollection = ImageCollection(
            id: tvSeries.id,
            posterPaths: [],
            backdropPaths: [],
            logoPaths: [URL(string: "/logo.jpg")].compactMap(\.self)
        )
        let mapper = TVSeriesDetailsMapper()

        let result = mapper.map(
            tvSeries,
            imageCollection: imageCollection,
            imagesConfiguration: imagesConfiguration
        )

        let expectedPosterURLSet = imagesConfiguration.posterURLSet(for: tvSeries.posterPath)
        let expectedBackdropURLSet = imagesConfiguration.posterURLSet(for: tvSeries.backdropPath)
        let expectedLogoURLSet = imagesConfiguration.logoURLSet(for: imageCollection.logoPaths.first)

        #expect(result.id == tvSeries.id)
        #expect(result.name == tvSeries.name)
        #expect(result.overview == tvSeries.overview)
        #expect(result.posterURLSet == expectedPosterURLSet)
        #expect(result.backdropURLSet == expectedBackdropURLSet)
        #expect(result.logoURLSet == expectedLogoURLSet)
    }

    @Test("map should return nil URL sets when paths are missing")
    func map_shouldReturnNilURLSetsWhenPathsAreMissing() {
        let tvSeries = TVSeries.mock(
            id: 404,
            name: "No Images",
            overview: "",
            posterPath: nil,
            backdropPath: nil
        )
        let imageCollection = ImageCollection(
            id: tvSeries.id,
            posterPaths: [],
            backdropPaths: [],
            logoPaths: []
        )
        let mapper = TVSeriesDetailsMapper()

        let result = mapper.map(
            tvSeries,
            imageCollection: imageCollection,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.id == tvSeries.id)
        #expect(result.name == tvSeries.name)
        #expect(result.overview == tvSeries.overview)
        #expect(result.posterURLSet == nil)
        #expect(result.backdropURLSet == nil)
        #expect(result.logoURLSet == nil)
    }

    @Test("map includes seasons in TV series details")
    func map_includesSeasonsInTVSeriesDetails() {
        let season1 = TVSeason.mock(
            id: 77680,
            name: "Season 1",
            seasonNumber: 1,
            posterPath: URL(string: "/poster1.jpg")
        )
        let season2 = TVSeason.mock(
            id: 77681,
            name: "Season 2",
            seasonNumber: 2,
            posterPath: URL(string: "/poster2.jpg")
        )
        let tvSeries = TVSeries.mock(seasons: [season1, season2])
        let imageCollection = ImageCollection(id: tvSeries.id, posterPaths: [], backdropPaths: [], logoPaths: [])
        let mapper = TVSeriesDetailsMapper()

        let result = mapper.map(tvSeries, imageCollection: imageCollection, imagesConfiguration: imagesConfiguration)

        #expect(result.seasons.count == 2)
        #expect(result.seasons[0].id == 77680)
        #expect(result.seasons[0].name == "Season 1")
        #expect(result.seasons[0].seasonNumber == 1)
        #expect(result.seasons[1].id == 77681)
        #expect(result.seasons[1].seasonNumber == 2)
    }

    @Test("map returns empty seasons when TV series has no seasons")
    func map_returnsEmptySeasonsWhenNoSeasons() {
        let tvSeries = TVSeries.mock(seasons: [])
        let imageCollection = ImageCollection(id: tvSeries.id, posterPaths: [], backdropPaths: [], logoPaths: [])
        let mapper = TVSeriesDetailsMapper()

        let result = mapper.map(tvSeries, imageCollection: imageCollection, imagesConfiguration: imagesConfiguration)

        #expect(result.seasons.isEmpty)
    }

    @Test("map passes genres through to TV series details")
    func map_passesGenresThroughToTVSeriesDetails() {
        let genres = [
            Genre(id: 18, name: "Drama"),
            Genre(id: 80, name: "Crime")
        ]
        let tvSeries = TVSeries.mock(genres: genres)
        let imageCollection = ImageCollection(id: tvSeries.id, posterPaths: [], backdropPaths: [], logoPaths: [])
        let mapper = TVSeriesDetailsMapper()

        let result = mapper.map(tvSeries, imageCollection: imageCollection, imagesConfiguration: imagesConfiguration)

        #expect(result.genres == genres)
    }

    @Test("map passes nil genres through to TV series details")
    func map_passesNilGenresThroughToTVSeriesDetails() {
        let tvSeries = TVSeries.mock(genres: nil)
        let imageCollection = ImageCollection(id: tvSeries.id, posterPaths: [], backdropPaths: [], logoPaths: [])
        let mapper = TVSeriesDetailsMapper()

        let result = mapper.map(tvSeries, imageCollection: imageCollection, imagesConfiguration: imagesConfiguration)

        #expect(result.genres == nil)
    }

}
