//
//  WatchProviderMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

struct WatchProviderMapperTests {

    private let mapper = WatchProviderMapper()

    @Test
    func `map converts all properties correctly`() throws {
        let logoPath = try #require(URL(string: "https://tmdb.example/logo.png"))

        let tmdbProvider = TMDb.WatchProvider(
            id: 8,
            name: "Netflix",
            logoPath: logoPath
        )

        let result = mapper.map(tmdbProvider)

        #expect(result.id == 8)
        #expect(result.name == "Netflix")
        #expect(result.logoPath == logoPath)
    }

    @Test
    func `map handles nil logo path`() {
        let tmdbProvider = TMDb.WatchProvider(
            id: 337,
            name: "Disney Plus",
            logoPath: nil
        )

        let result = mapper.map(tmdbProvider)

        #expect(result.id == 337)
        #expect(result.name == "Disney Plus")
        #expect(result.logoPath == nil)
    }

}
