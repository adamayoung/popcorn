//
//  MoviePreviewMapperTests.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverApplication
import DiscoverDomain
@testable import ExploreFeature
import Foundation
import MoviesApplication
import Testing
import TrendingApplication

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    private let mapper = MoviePreviewMapper()

    // MARK: - TrendingApplication.MoviePreviewDetails Tests

    @Test("Maps TrendingApplication MoviePreviewDetails to MoviePreview")
    func mapsTrendingMoviePreviewDetails() throws {
        let imageURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let details = TrendingApplication.MoviePreviewDetails(
            id: 798_645,
            title: "The Running Man",
            overview: "A thrilling action movie.",
            posterURLSet: imageURLSet,
            backdropURLSet: imageURLSet,
            logoURLSet: imageURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 798_645)
        #expect(result.title == "The Running Man")
        #expect(result.posterURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/thumbnail.jpg"))
    }

    @Test("Maps TrendingApplication MoviePreviewDetails with nil URL sets")
    func mapsTrendingMoviePreviewDetailsWithNilURLSets() {
        let details = TrendingApplication.MoviePreviewDetails(
            id: 123,
            title: "Test Movie",
            overview: "Test overview"
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.posterURL == nil)
        #expect(result.backdropURL == nil)
        #expect(result.logoURL == nil)
    }

    // MARK: - MoviesApplication.MoviePreviewDetails Tests

    @Test("Maps MoviesApplication MoviePreviewDetails to MoviePreview")
    func mapsMoviesMoviePreviewDetails() throws {
        let imageURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let details = MoviesApplication.MoviePreviewDetails(
            id: 456,
            title: "Fight Club",
            overview: "An insomniac and a soap salesman.",
            posterURLSet: imageURLSet,
            backdropURLSet: imageURLSet,
            logoURLSet: imageURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 456)
        #expect(result.title == "Fight Club")
        #expect(result.posterURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/thumbnail.jpg"))
    }

    // MARK: - DiscoverApplication.MoviePreviewDetails Tests

    @Test("Maps DiscoverApplication MoviePreviewDetails to MoviePreview")
    func mapsDiscoverMoviePreviewDetails() throws {
        let imageURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )
        let genres = [DiscoverDomain.Genre(id: 28, name: "Action")]

        let details = DiscoverApplication.MoviePreviewDetails(
            id: 789,
            title: "Inception",
            overview: "A dream within a dream.",
            releaseDate: Date(timeIntervalSince1970: 1_279_238_400),
            genres: genres,
            posterURLSet: imageURLSet,
            backdropURLSet: imageURLSet,
            logoURLSet: imageURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 789)
        #expect(result.title == "Inception")
        #expect(result.posterURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/detail.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/thumbnail.jpg"))
    }

}
