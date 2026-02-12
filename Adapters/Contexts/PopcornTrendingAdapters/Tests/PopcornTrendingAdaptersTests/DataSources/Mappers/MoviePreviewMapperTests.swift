//
//  MoviePreviewMapperTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TMDb
import TrendingDomain

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    private let mapper = MoviePreviewMapper()

    @Test("Maps all properties from TMDb MovieListItem to MoviePreview")
    func mapsAllProperties() throws {
        let posterPath = try #require(URL(string: "https://example.com/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://example.com/backdrop.jpg"))

        let tmdbMovie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac meets a slippery soap salesman.",
            genreIDs: [18, 53],
            releaseDate: Date(timeIntervalSince1970: 939_686_400),
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 61.416,
            voteAverage: 8.433,
            voteCount: 27044,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A ticking-time-bomb insomniac meets a slippery soap salesman.")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let tmdbMovie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A movie about fighting.",
            genreIDs: [],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A movie about fighting.")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps empty overview string")
    func mapsEmptyOverviewString() {
        let tmdbMovie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.overview == "")
    }

    @Test("Maps poster path only when provided")
    func mapsPosterPathOnlyWhenProvided() throws {
        let posterPath = try #require(URL(string: "https://example.com/poster.jpg"))

        let tmdbMovie = MovieListItem(
            id: 123,
            title: "Test Movie",
            originalTitle: "Test Movie",
            originalLanguage: "en",
            overview: "Test overview",
            genreIDs: [],
            releaseDate: nil,
            posterPath: posterPath,
            backdropPath: nil
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps backdrop path only when provided")
    func mapsBackdropPathOnlyWhenProvided() throws {
        let backdropPath = try #require(URL(string: "https://example.com/backdrop.jpg"))

        let tmdbMovie = MovieListItem(
            id: 123,
            title: "Test Movie",
            originalTitle: "Test Movie",
            originalLanguage: "en",
            overview: "Test overview",
            genreIDs: [],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: backdropPath
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.posterPath == nil)
        #expect(result.backdropPath == backdropPath)
    }

}
