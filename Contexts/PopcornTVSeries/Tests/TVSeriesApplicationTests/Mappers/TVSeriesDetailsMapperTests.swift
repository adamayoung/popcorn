//
//  TVSeriesDetailsMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import Testing
import TVSeriesDomain

@testable import TVSeriesApplication

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

}
