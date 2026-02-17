//
//  MovieCollectionMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("MovieCollectionMapper Tests")
struct MovieCollectionMapperTests {

    private let mapper = MovieCollectionMapper()

    @Test("Maps all properties from TMDb to domain")
    func mapsAllProperties() {
        let tmdbCollection = TMDb.BelongsToCollection(
            id: 119,
            name: "The Lord of the Rings Collection",
            posterPath: URL(string: "/oENY593nKRVL2PnxXsMtlh8izb4.jpg"),
            backdropPath: URL(string: "/bccR2CGTWVVSZAG0yqmy3DIvhTX.jpg")
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 119)
        #expect(result.name == "The Lord of the Rings Collection")
        #expect(result.posterPath == URL(string: "/oENY593nKRVL2PnxXsMtlh8izb4.jpg"))
        #expect(result.backdropPath == URL(string: "/bccR2CGTWVVSZAG0yqmy3DIvhTX.jpg"))
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let tmdbCollection = TMDb.BelongsToCollection(
            id: 119,
            name: "The Lord of the Rings Collection",
            posterPath: nil,
            backdropPath: nil
        )

        let result = mapper.map(tmdbCollection)

        #expect(result.id == 119)
        #expect(result.name == "The Lord of the Rings Collection")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

}
