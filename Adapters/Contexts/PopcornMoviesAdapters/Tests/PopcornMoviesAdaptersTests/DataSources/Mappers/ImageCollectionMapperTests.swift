//
//  ImageCollectionMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("ImageCollectionMapper Tests")
struct ImageCollectionMapperTests {

    private let mapper = ImageCollectionMapper()

    @Test("map converts TMDb image collection to domain model")
    func mapConvertsTMDbImageCollectionToDomainModel() throws {
        let poster = try makeImageMetadata(path: "https://tmdb.example/poster.jpg")
        let backdrop = try makeImageMetadata(path: "https://tmdb.example/backdrop.jpg")
        let logo = try makeImageMetadata(path: "https://tmdb.example/logo.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 550,
            posters: [poster],
            logos: [logo],
            backdrops: [backdrop]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 550)
        #expect(result.posterPaths == [poster.filePath])
        #expect(result.backdropPaths == [backdrop.filePath])
        #expect(result.logoPaths == [logo.filePath])
    }

    @Test("map handles empty poster array")
    func mapHandlesEmptyPosterArray() throws {
        let backdrop = try makeImageMetadata(path: "https://tmdb.example/backdrop.jpg")
        let logo = try makeImageMetadata(path: "https://tmdb.example/logo.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 550,
            posters: [],
            logos: [logo],
            backdrops: [backdrop]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.posterPaths.isEmpty)
        #expect(result.backdropPaths.count == 1)
        #expect(result.logoPaths.count == 1)
    }

    @Test("map handles empty backdrop array")
    func mapHandlesEmptyBackdropArray() throws {
        let poster = try makeImageMetadata(path: "https://tmdb.example/poster.jpg")
        let logo = try makeImageMetadata(path: "https://tmdb.example/logo.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 550,
            posters: [poster],
            logos: [logo],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.posterPaths.count == 1)
        #expect(result.backdropPaths.isEmpty)
        #expect(result.logoPaths.count == 1)
    }

    @Test("map handles empty logo array")
    func mapHandlesEmptyLogoArray() throws {
        let poster = try makeImageMetadata(path: "https://tmdb.example/poster.jpg")
        let backdrop = try makeImageMetadata(path: "https://tmdb.example/backdrop.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 550,
            posters: [poster],
            logos: [],
            backdrops: [backdrop]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.posterPaths.count == 1)
        #expect(result.backdropPaths.count == 1)
        #expect(result.logoPaths.isEmpty)
    }

    @Test("map handles all empty arrays")
    func mapHandlesAllEmptyArrays() {
        let tmdbCollection = TMDb.ImageCollection(
            id: 550,
            posters: [],
            logos: [],
            backdrops: []
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 550)
        #expect(result.posterPaths.isEmpty)
        #expect(result.backdropPaths.isEmpty)
        #expect(result.logoPaths.isEmpty)
    }

    @Test("map handles multiple images per category")
    func mapHandlesMultipleImagesPerCategory() throws {
        let poster1 = try makeImageMetadata(path: "https://tmdb.example/poster1.jpg")
        let poster2 = try makeImageMetadata(path: "https://tmdb.example/poster2.jpg")
        let backdrop1 = try makeImageMetadata(path: "https://tmdb.example/backdrop1.jpg")
        let backdrop2 = try makeImageMetadata(path: "https://tmdb.example/backdrop2.jpg")
        let logo1 = try makeImageMetadata(path: "https://tmdb.example/logo1.jpg")
        let logo2 = try makeImageMetadata(path: "https://tmdb.example/logo2.jpg")

        let tmdbCollection = TMDb.ImageCollection(
            id: 550,
            posters: [poster1, poster2],
            logos: [logo1, logo2],
            backdrops: [backdrop1, backdrop2]
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.posterPaths.count == 2)
        #expect(result.backdropPaths.count == 2)
        #expect(result.logoPaths.count == 2)
        #expect(result.posterPaths[0] == poster1.filePath)
        #expect(result.posterPaths[1] == poster2.filePath)
    }

}

private extension ImageCollectionMapperTests {

    func makeImageMetadata(path: String) throws -> ImageMetadata {
        try ImageMetadata(
            filePath: #require(URL(string: path)),
            width: 500,
            height: 750,
            aspectRatio: 0.66,
            voteAverage: nil,
            voteCount: nil
        )
    }

}
