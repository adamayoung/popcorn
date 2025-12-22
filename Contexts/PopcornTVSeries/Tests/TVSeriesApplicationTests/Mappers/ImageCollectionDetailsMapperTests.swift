//
//  ImageCollectionDetailsMapperTests.swift
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

@Suite("ImageCollectionDetailsMapperTests")
struct ImageCollectionDetailsMapperTests {

    let imagesConfiguration: ImagesConfiguration

    init() {
        self.imagesConfiguration = ImagesConfiguration.mock()
    }

    @Test("map should return image collection details")
    func map_shouldReturnImageCollectionDetails() {
        let imageCollection = ImageCollection(
            id: 101,
            posterPaths: [URL(string: "/poster.jpg")].compactMap(\.self),
            backdropPaths: [URL(string: "/backdrop.jpg")].compactMap(\.self),
            logoPaths: [URL(string: "/logo.jpg")].compactMap(\.self)
        )
        let mapper = ImageCollectionDetailsMapper()

        let result = mapper.map(imageCollection, imagesConfiguration: imagesConfiguration)

        let expectedPosterURLSets = imageCollection.posterPaths.compactMap {
            imagesConfiguration.posterURLSet(for: $0)
        }
        let expectedBackdropURLSets = imageCollection.backdropPaths.compactMap {
            imagesConfiguration.posterURLSet(for: $0)
        }
        let expectedLogoURLSets = imageCollection.logoPaths.compactMap {
            imagesConfiguration.logoURLSet(for: $0)
        }

        #expect(result.id == imageCollection.id)
        #expect(result.posterURLSets == expectedPosterURLSets)
        #expect(result.backdropURLSets == expectedBackdropURLSets)
        #expect(result.logoURLSets == expectedLogoURLSets)
    }

    @Test("map should return empty URL sets for empty paths")
    func map_shouldReturnEmptyURLSetsForEmptyPaths() {
        let imageCollection = ImageCollection(
            id: 202,
            posterPaths: [],
            backdropPaths: [],
            logoPaths: []
        )
        let mapper = ImageCollectionDetailsMapper()

        let result = mapper.map(imageCollection, imagesConfiguration: imagesConfiguration)

        #expect(result.id == imageCollection.id)
        #expect(result.posterURLSets.isEmpty)
        #expect(result.backdropURLSets.isEmpty)
        #expect(result.logoURLSets.isEmpty)
    }

}
