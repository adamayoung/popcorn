//
//  ImageCollectionMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Testing
import TMDb
import TVSeriesDomain

@testable import PopcornTVSeriesAdapters

@Suite("ImageCollectionMapper Tests")
struct ImageCollectionMapperTests {

    @Test("map converts TMDb image collection to domain model")
    func map_convertsTMDbImageCollectionToDomainModel() throws {
        let poster = try ImageMetadata(
            filePath: #require(URL(string: "https://tmdb.example/poster.jpg")),
            width: 500,
            height: 750,
            aspectRatio: 0.66,
            voteAverage: nil,
            voteCount: nil
        )
        let backdrop = try ImageMetadata(
            filePath: #require(URL(string: "https://tmdb.example/backdrop.jpg")),
            width: 1280,
            height: 720,
            aspectRatio: 1.77,
            voteAverage: nil,
            voteCount: nil
        )
        let logo = try ImageMetadata(
            filePath: #require(URL(string: "https://tmdb.example/logo.jpg")),
            width: 300,
            height: 100,
            aspectRatio: 3.0,
            voteAverage: nil,
            voteCount: nil
        )
        let tmdbCollection = ImageCollection(
            id: 902,
            posters: [poster],
            logos: [logo],
            backdrops: [backdrop]
        )

        let mapper = ImageCollectionMapper()
        let result = mapper.map(tmdbCollection)

        #expect(result.id == 902)
        #expect(result.posterPaths == [poster.filePath])
        #expect(result.backdropPaths == [backdrop.filePath])
        #expect(result.logoPaths == [logo.filePath])
    }

}
