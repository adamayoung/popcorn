//
//  MovieMapperTests.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import MovieIntelligenceFeature
import MoviesApplication
import MoviesDomain
import Testing

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps MovieDetails to Movie")
    func mapsMovieDetails() throws {
        let imageURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let details = MovieDetails(
            id: 798_645,
            title: "The Running Man",
            tagline: "The race for survival begins.",
            overview: "A thrilling action movie.",
            runtime: 120,
            genres: nil,
            releaseDate: nil,
            posterURLSet: imageURLSet,
            backdropURLSet: imageURLSet,
            logoURLSet: imageURLSet,
            budget: 100_000_000,
            revenue: 250_000_000,
            homepageURL: URL(string: "https://example.com"),
            isOnWatchlist: true
        )

        let result = mapper.map(details)

        #expect(result.id == 798_645)
        #expect(result.title == "The Running Man")
    }

    @Test("Maps multiple movies correctly")
    func mapsMultipleMovies() {
        let details1 = MovieDetails(
            id: 1,
            title: "Movie 1",
            overview: "Overview 1",
            isOnWatchlist: false
        )
        let details2 = MovieDetails(
            id: 2,
            title: "Movie 2",
            overview: "Overview 2",
            isOnWatchlist: false
        )

        let results = [details1, details2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].title == "Movie 1")
        #expect(results[1].id == 2)
        #expect(results[1].title == "Movie 2")
    }

}
