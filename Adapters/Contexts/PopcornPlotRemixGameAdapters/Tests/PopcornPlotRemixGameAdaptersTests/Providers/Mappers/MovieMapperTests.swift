//
//  MovieMapperTests.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverApplication
import DiscoverDomain
import Foundation
import MoviesApplication
import PlotRemixGameDomain
@testable import PopcornPlotRemixGameAdapters
import Testing

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    // MARK: - DiscoverApplication.MoviePreviewDetails Mapping Tests

    @Test("Maps DiscoverApplication.MoviePreviewDetails with all properties")
    func mapsDiscoverMoviePreviewDetailsWithAllProperties() throws {
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))

        let posterURLSet = try ImageURLSet(
            path: posterPath,
            thumbnail: #require(URL(string: "https://example.com/poster_thumb.jpg")),
            card: #require(URL(string: "https://example.com/poster_card.jpg")),
            detail: #require(URL(string: "https://example.com/poster_detail.jpg")),
            full: #require(URL(string: "https://example.com/poster_full.jpg"))
        )

        let backdropURLSet = try ImageURLSet(
            path: backdropPath,
            thumbnail: #require(URL(string: "https://example.com/backdrop_thumb.jpg")),
            card: #require(URL(string: "https://example.com/backdrop_card.jpg")),
            detail: #require(URL(string: "https://example.com/backdrop_detail.jpg")),
            full: #require(URL(string: "https://example.com/backdrop_full.jpg"))
        )

        let source = DiscoverApplication.MoviePreviewDetails(
            id: 550,
            title: "Fight Club",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            releaseDate: Date(timeIntervalSince1970: 939_686_400),
            genres: [DiscoverDomain.Genre(id: 18, name: "Drama")],
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )

        let result = mapper.map(source)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A ticking-time-bomb insomniac and a slippery soap salesman...")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("Maps DiscoverApplication.MoviePreviewDetails with nil URL sets")
    func mapsDiscoverMoviePreviewDetailsWithNilURLSets() {
        let source = DiscoverApplication.MoviePreviewDetails(
            id: 550,
            title: "Fight Club",
            overview: "A ticking-time-bomb insomniac",
            releaseDate: Date(),
            genres: [],
            posterURLSet: nil,
            backdropURLSet: nil
        )

        let result = mapper.map(source)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A ticking-time-bomb insomniac")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps DiscoverApplication.MoviePreviewDetails with empty overview")
    func mapsDiscoverMoviePreviewDetailsWithEmptyOverview() {
        let source = DiscoverApplication.MoviePreviewDetails(
            id: 123,
            title: "Test Movie",
            overview: "",
            releaseDate: Date(),
            genres: []
        )

        let result = mapper.map(source)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.overview == "")
    }

    // MARK: - MoviesApplication.MoviePreviewDetails Mapping Tests

    @Test("Maps MoviesApplication.MoviePreviewDetails with all properties")
    func mapsMoviesMoviePreviewDetailsWithAllProperties() throws {
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))

        let posterURLSet = try ImageURLSet(
            path: posterPath,
            thumbnail: #require(URL(string: "https://example.com/poster_thumb.jpg")),
            card: #require(URL(string: "https://example.com/poster_card.jpg")),
            detail: #require(URL(string: "https://example.com/poster_detail.jpg")),
            full: #require(URL(string: "https://example.com/poster_full.jpg"))
        )

        let backdropURLSet = try ImageURLSet(
            path: backdropPath,
            thumbnail: #require(URL(string: "https://example.com/backdrop_thumb.jpg")),
            card: #require(URL(string: "https://example.com/backdrop_card.jpg")),
            detail: #require(URL(string: "https://example.com/backdrop_detail.jpg")),
            full: #require(URL(string: "https://example.com/backdrop_full.jpg"))
        )

        let source = MoviesApplication.MoviePreviewDetails(
            id: 550,
            title: "Fight Club",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )

        let result = mapper.map(source)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A ticking-time-bomb insomniac and a slippery soap salesman...")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("Maps MoviesApplication.MoviePreviewDetails with nil URL sets")
    func mapsMoviesMoviePreviewDetailsWithNilURLSets() {
        let source = MoviesApplication.MoviePreviewDetails(
            id: 550,
            title: "Fight Club",
            overview: "A ticking-time-bomb insomniac",
            posterURLSet: nil,
            backdropURLSet: nil
        )

        let result = mapper.map(source)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A ticking-time-bomb insomniac")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps MoviesApplication.MoviePreviewDetails with empty overview")
    func mapsMoviesMoviePreviewDetailsWithEmptyOverview() {
        let source = MoviesApplication.MoviePreviewDetails(
            id: 123,
            title: "Test Movie",
            overview: ""
        )

        let result = mapper.map(source)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.overview == "")
    }

    @Test("Maps MoviesApplication.MoviePreviewDetails preserves exact data")
    func mapsMoviesMoviePreviewDetailsPreservesExactData() throws {
        let posterPath = try #require(URL(string: "/special/path/poster.jpg"))
        let backdropPath = try #require(URL(string: "/special/path/backdrop.jpg"))

        let posterURLSet = try ImageURLSet(
            path: posterPath,
            thumbnail: #require(URL(string: "https://example.com/thumb.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let backdropURLSet = try ImageURLSet(
            path: backdropPath,
            thumbnail: #require(URL(string: "https://example.com/thumb.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let source = MoviesApplication.MoviePreviewDetails(
            id: 999,
            title: "Special Characters: Test & More",
            overview: "Overview with special chars: <>&\"'",
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )

        let result = mapper.map(source)

        #expect(result.id == 999)
        #expect(result.title == "Special Characters: Test & More")
        #expect(result.overview == "Overview with special chars: <>&\"'")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

}
