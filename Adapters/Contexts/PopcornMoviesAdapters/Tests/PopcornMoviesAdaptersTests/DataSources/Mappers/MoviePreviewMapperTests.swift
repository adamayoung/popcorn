//
//  MoviePreviewMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    private let mapper = MoviePreviewMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let posterPath = try #require(URL(string: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"))
        let backdropPath = try #require(URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"))
        let releaseDate = Date(timeIntervalSince1970: 939_686_400) // 1999-10-12

        let tmdbMovie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal " +
                "male aggression into a shocking new form of therapy.",
            genreIDs: [18, 53, 35],
            releaseDate: releaseDate,
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
        #expect(result.overview.contains("ticking-time-bomb"))
        #expect(result.releaseDate == releaseDate)
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("map handles nil optional properties")
    func mapHandlesNilOptionalProperties() {
        let tmdbMovie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "Overview text",
            genreIDs: [],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil,
            popularity: 61.416,
            voteAverage: 8.433,
            voteCount: 27044,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.releaseDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("map preserves overview text")
    func mapPreservesOverviewText() {
        let overview = "This is a detailed plot summary that should be preserved exactly as is."
        let tmdbMovie = MovieListItem(
            id: 123,
            title: "Test Movie",
            originalTitle: "Test Movie",
            originalLanguage: "en",
            overview: overview,
            genreIDs: [],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil,
            popularity: 1.0,
            voteAverage: 7.0,
            voteCount: 100,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.overview == overview)
    }

    @Test("map handles empty overview")
    func mapHandlesEmptyOverview() {
        let tmdbMovie = MovieListItem(
            id: 123,
            title: "Test Movie",
            originalTitle: "Test Movie",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil,
            popularity: 1.0,
            voteAverage: 7.0,
            voteCount: 100,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.overview.isEmpty)
    }

    @Test("map converts array of movies correctly")
    func mapConvertsArrayOfMoviesCorrectly() {
        let tmdbMovies = [
            MovieListItem(
                id: 550,
                title: "Fight Club",
                originalTitle: "Fight Club",
                originalLanguage: "en",
                overview: "Overview 1",
                genreIDs: [],
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                popularity: 1.0,
                voteAverage: 8.4,
                voteCount: 100,
                hasVideo: false,
                isAdultOnly: false
            ),
            MovieListItem(
                id: 551,
                title: "Se7en",
                originalTitle: "Se7en",
                originalLanguage: "en",
                overview: "Overview 2",
                genreIDs: [],
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                popularity: 1.0,
                voteAverage: 8.3,
                voteCount: 100,
                hasVideo: false,
                isAdultOnly: false
            )
        ]

        let results = tmdbMovies.map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 550)
        #expect(results[0].title == "Fight Club")
        #expect(results[1].id == 551)
        #expect(results[1].title == "Se7en")
    }

}
