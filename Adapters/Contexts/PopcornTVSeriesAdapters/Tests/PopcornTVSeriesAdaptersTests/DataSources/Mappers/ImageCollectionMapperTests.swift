//
//  ImageCollectionMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("ImageCollectionMapper Tests")
struct ImageCollectionMapperTests {

    private let mapper = ImageCollectionMapper()

    // MARK: - Breaking Bad Test Data (ID: 1396)

    @Test("Maps all properties from TMDb image collection to domain model using Breaking Bad")
    func mapsAllPropertiesUsingBreakingBad() throws {
        let poster1 = try makeImageMetadata(path: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg")
        let poster2 = try makeImageMetadata(path: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg")
        let backdrop1 = try makeImageMetadata(path: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg")
        let backdrop2 = try makeImageMetadata(path: "/84XPpjGvxNyExjSuLQe0SzioErt.jpg")
        let logo1 = try makeImageMetadata(path: "/y2p9BpuWYdzfG9SH7o3GEu7kxCW.png")
        let logo2 = try makeImageMetadata(path: "/30VRpqLqpE7Gu7nZYNvSZILk8ES.png")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [poster1, poster2],
            logos: [logo1, logo2],
            backdrops: [backdrop1, backdrop2]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 1396)
        #expect(result.posterPaths.count == 2)
        #expect(result.posterPaths[0] == poster1.filePath)
        #expect(result.posterPaths[1] == poster2.filePath)
        #expect(result.backdropPaths.count == 2)
        #expect(result.backdropPaths[0] == backdrop1.filePath)
        #expect(result.backdropPaths[1] == backdrop2.filePath)
        #expect(result.logoPaths.count == 2)
        #expect(result.logoPaths[0] == logo1.filePath)
        #expect(result.logoPaths[1] == logo2.filePath)
    }

    @Test("Maps with empty posters array")
    func mapsWithEmptyPostersArray() throws {
        let backdrop = try makeImageMetadata(path: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg")
        let logo = try makeImageMetadata(path: "/y2p9BpuWYdzfG9SH7o3GEu7kxCW.png")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [],
            logos: [logo],
            backdrops: [backdrop]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 1396)
        #expect(result.posterPaths.isEmpty)
        #expect(result.backdropPaths.count == 1)
        #expect(result.logoPaths.count == 1)
    }

    @Test("Maps with empty backdrops array")
    func mapsWithEmptyBackdropsArray() throws {
        let poster = try makeImageMetadata(path: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg")
        let logo = try makeImageMetadata(path: "/y2p9BpuWYdzfG9SH7o3GEu7kxCW.png")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [poster],
            logos: [logo],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 1396)
        #expect(result.posterPaths.count == 1)
        #expect(result.backdropPaths.isEmpty)
        #expect(result.logoPaths.count == 1)
    }

    @Test("Maps with empty logos array")
    func mapsWithEmptyLogosArray() throws {
        let poster = try makeImageMetadata(path: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg")
        let backdrop = try makeImageMetadata(path: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [poster],
            logos: [],
            backdrops: [backdrop]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 1396)
        #expect(result.posterPaths.count == 1)
        #expect(result.backdropPaths.count == 1)
        #expect(result.logoPaths.isEmpty)
    }

    @Test("Maps with all empty arrays")
    func mapsWithAllEmptyArrays() {
        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [],
            logos: [],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 1396)
        #expect(result.posterPaths.isEmpty)
        #expect(result.backdropPaths.isEmpty)
        #expect(result.logoPaths.isEmpty)
    }

    @Test("Maps single poster correctly")
    func mapsSinglePosterCorrectly() throws {
        let poster = try makeImageMetadata(path: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [poster],
            logos: [],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.posterPaths.count == 1)
        #expect(result.posterPaths[0] == poster.filePath)
    }

    @Test("Maps single backdrop correctly")
    func mapsSingleBackdropCorrectly() throws {
        let backdrop = try makeImageMetadata(path: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [],
            logos: [],
            backdrops: [backdrop]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.backdropPaths.count == 1)
        #expect(result.backdropPaths[0] == backdrop.filePath)
    }

    @Test("Maps single logo correctly")
    func mapsSingleLogoCorrectly() throws {
        let logo = try makeImageMetadata(path: "/y2p9BpuWYdzfG9SH7o3GEu7kxCW.png")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [],
            logos: [logo],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.logoPaths.count == 1)
        #expect(result.logoPaths[0] == logo.filePath)
    }

    @Test("Preserves order of posters")
    func preservesOrderOfPosters() throws {
        let poster1 = try makeImageMetadata(path: "/first.jpg")
        let poster2 = try makeImageMetadata(path: "/second.jpg")
        let poster3 = try makeImageMetadata(path: "/third.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [poster1, poster2, poster3],
            logos: [],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.posterPaths.count == 3)
        #expect(result.posterPaths[0] == poster1.filePath)
        #expect(result.posterPaths[1] == poster2.filePath)
        #expect(result.posterPaths[2] == poster3.filePath)
    }

    @Test("Preserves order of backdrops")
    func preservesOrderOfBackdrops() throws {
        let backdrop1 = try makeImageMetadata(path: "/first.jpg")
        let backdrop2 = try makeImageMetadata(path: "/second.jpg")
        let backdrop3 = try makeImageMetadata(path: "/third.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [],
            logos: [],
            backdrops: [backdrop1, backdrop2, backdrop3]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.backdropPaths.count == 3)
        #expect(result.backdropPaths[0] == backdrop1.filePath)
        #expect(result.backdropPaths[1] == backdrop2.filePath)
        #expect(result.backdropPaths[2] == backdrop3.filePath)
    }

    @Test("Preserves order of logos")
    func preservesOrderOfLogos() throws {
        let logo1 = try makeImageMetadata(path: "/first.png")
        let logo2 = try makeImageMetadata(path: "/second.png")
        let logo3 = try makeImageMetadata(path: "/third.png")

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: [],
            logos: [logo1, logo2, logo3],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.logoPaths.count == 3)
        #expect(result.logoPaths[0] == logo1.filePath)
        #expect(result.logoPaths[1] == logo2.filePath)
        #expect(result.logoPaths[2] == logo3.filePath)
    }

    @Test("Maps many images correctly")
    func mapsManyImagesCorrectly() throws {
        var posters: [TMDb.ImageMetadata] = []
        var backdrops: [TMDb.ImageMetadata] = []
        var logos: [TMDb.ImageMetadata] = []

        for index in 1 ... 10 {
            try posters.append(makeImageMetadata(path: "/poster\(index).jpg"))
            try backdrops.append(makeImageMetadata(path: "/backdrop\(index).jpg"))
            try logos.append(makeImageMetadata(path: "/logo\(index).png"))
        }

        let tmdbCollection = TMDb.ImageCollection(
            id: 1396,
            posters: posters,
            logos: logos,
            backdrops: backdrops
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.posterPaths.count == 10)
        #expect(result.backdropPaths.count == 10)
        #expect(result.logoPaths.count == 10)
    }

    @Test("Preserves exact id value")
    func preservesExactIdValue() {
        let tmdbCollection = TMDb.ImageCollection(
            id: 999_999,
            posters: [],
            logos: [],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 999_999)
    }

}

// MARK: - Test Helpers

private extension ImageCollectionMapperTests {

    func makeImageMetadata(path: String) throws -> TMDb.ImageMetadata {
        try TMDb.ImageMetadata(
            filePath: #require(URL(string: path)),
            width: 500,
            height: 750,
            aspectRatio: 0.66,
            voteAverage: nil,
            voteCount: nil
        )
    }

}
