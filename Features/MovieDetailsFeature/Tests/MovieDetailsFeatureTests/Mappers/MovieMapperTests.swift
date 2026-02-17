//
//  MovieMapperTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import MovieDetailsFeature
import MoviesApplication
import MoviesDomain
import Testing

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps all properties from MovieDetails to Movie")
    func mapsAllProperties() throws {
        let imageURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )
        let genres = [
            MoviesDomain.Genre(id: 28, name: "Action"),
            MoviesDomain.Genre(id: 878, name: "Science Fiction"),
            MoviesDomain.Genre(id: 53, name: "Thriller")
        ]
        let releaseDate = Date(timeIntervalSince1970: 1_748_390_400)

        let movieDetails = MovieDetails(
            id: 798_645,
            title: "The Running Man",
            tagline: "The race for survival begins.",
            overview: "A thrilling action movie.",
            runtime: 120,
            genres: genres,
            releaseDate: releaseDate,
            posterURLSet: imageURLSet,
            backdropURLSet: imageURLSet,
            logoURLSet: imageURLSet,
            budget: 100_000_000,
            revenue: 250_000_000,
            homepageURL: URL(string: "https://example.com"),
            isOnWatchlist: true
        )

        let result = mapper.map(movieDetails)

        #expect(result.id == 798_645)
        #expect(result.title == "The Running Man")
        #expect(result.tagline == "The race for survival begins.")
        #expect(result.overview == "A thrilling action movie.")
        #expect(result.runtime == 120)
        #expect(result.genres?.count == 3)
        #expect(result.genres?[0].id == 28)
        #expect(result.genres?[0].name == "Action")
        #expect(result.genres?[1].id == 878)
        #expect(result.genres?[1].name == "Science Fiction")
        #expect(result.genres?[2].id == 53)
        #expect(result.genres?[2].name == "Thriller")
        #expect(result.releaseDate == releaseDate)
        #expect(result.posterURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/full.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.budget == 100_000_000)
        #expect(result.revenue == 250_000_000)
        #expect(result.homepageURL == URL(string: "https://example.com"))
        #expect(result.isOnWatchlist == true)
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let movieDetails = MovieDetails(
            id: 123,
            title: "Test Movie",
            tagline: nil,
            overview: "Test overview",
            runtime: nil,
            genres: nil,
            releaseDate: nil,
            posterURLSet: nil,
            backdropURLSet: nil,
            logoURLSet: nil,
            budget: nil,
            revenue: nil,
            homepageURL: nil,
            isOnWatchlist: false
        )

        let result = mapper.map(movieDetails)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.tagline == nil)
        #expect(result.overview == "Test overview")
        #expect(result.runtime == nil)
        #expect(result.genres == nil)
        #expect(result.releaseDate == nil)
        #expect(result.posterURL == nil)
        #expect(result.backdropURL == nil)
        #expect(result.logoURL == nil)
        #expect(result.budget == nil)
        #expect(result.revenue == nil)
        #expect(result.homepageURL == nil)
        #expect(result.isOnWatchlist == false)
    }

    @Test("Maps with empty genres array")
    func mapsWithEmptyGenresArray() {
        let movieDetails = MovieDetails(
            id: 456,
            title: "Movie Without Genres",
            overview: "Test overview",
            genres: [],
            isOnWatchlist: false
        )

        let result = mapper.map(movieDetails)

        #expect(result.genres?.isEmpty == true)
    }

    @Test("Correctly extracts URLs from ImageURLSet")
    func extractsURLsFromImageURLSet() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster-full.jpg"))
        )
        let backdropURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/backdrop-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/backdrop-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/backdrop-card.jpg")),
            detail: #require(URL(string: "https://example.com/backdrop-detail.jpg")),
            full: #require(URL(string: "https://example.com/backdrop-full.jpg"))
        )
        let logoURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/logo-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/logo-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/logo-card.jpg")),
            detail: #require(URL(string: "https://example.com/logo-detail.jpg")),
            full: #require(URL(string: "https://example.com/logo-full.jpg"))
        )

        let movieDetails = MovieDetails(
            id: 789,
            title: "Test URLs",
            overview: "Test overview",
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet,
            isOnWatchlist: false
        )

        let result = mapper.map(movieDetails)

        #expect(result.posterURL == URL(string: "https://example.com/poster-detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/backdrop-full.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/logo-detail.jpg"))
    }

}
