//
//  WatchProviderCollectionMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

struct WatchProviderCollectionMapperTests {

    private let mapper = WatchProviderCollectionMapper()

    @Test
    func `map converts all provider types correctly`() throws {
        let link = "https://www.themoviedb.org/movie/550/watch"
        let streamingProvider = TMDb.WatchProvider(id: 8, name: "Netflix")
        let buyProvider = TMDb.WatchProvider(id: 2, name: "Apple TV")
        let rentProvider = TMDb.WatchProvider(id: 3, name: "Amazon")
        let freeProvider = TMDb.WatchProvider(id: 300, name: "Plex")

        let dto = TMDb.ShowWatchProvider(
            link: link,
            free: [freeProvider],
            flatRate: [streamingProvider],
            buy: [buyProvider],
            rent: [rentProvider]
        )

        let result = try #require(mapper.map(movieID: 550, dto))

        #expect(result.id == 550)
        #expect(result.link == URL(string: link))
        #expect(result.streamingProviders.count == 1)
        #expect(result.streamingProviders[0].name == "Netflix")
        #expect(result.buyProviders.count == 1)
        #expect(result.buyProviders[0].name == "Apple TV")
        #expect(result.rentProviders.count == 1)
        #expect(result.rentProviders[0].name == "Amazon")
        #expect(result.freeProviders.count == 1)
        #expect(result.freeProviders[0].name == "Plex")
    }

    @Test
    func `map handles nil provider arrays`() throws {
        let dto = TMDb.ShowWatchProvider(
            link: "https://www.themoviedb.org/movie/1/watch",
            free: nil,
            flatRate: nil,
            buy: nil,
            rent: nil
        )

        let result = try #require(mapper.map(movieID: 1, dto))

        #expect(result.streamingProviders.isEmpty)
        #expect(result.buyProviders.isEmpty)
        #expect(result.rentProviders.isEmpty)
        #expect(result.freeProviders.isEmpty)
    }

    @Test
    func `map converts multiple streaming providers`() throws {
        let dto = TMDb.ShowWatchProvider(
            link: "https://www.themoviedb.org/movie/1/watch",
            flatRate: [
                TMDb.WatchProvider(id: 8, name: "Netflix"),
                TMDb.WatchProvider(id: 337, name: "Disney Plus"),
                TMDb.WatchProvider(id: 15, name: "Hulu")
            ]
        )

        let result = try #require(mapper.map(movieID: 1, dto))

        #expect(result.streamingProviders.count == 3)
        #expect(result.streamingProviders[0].id == 8)
        #expect(result.streamingProviders[1].id == 337)
        #expect(result.streamingProviders[2].id == 15)
    }

}
