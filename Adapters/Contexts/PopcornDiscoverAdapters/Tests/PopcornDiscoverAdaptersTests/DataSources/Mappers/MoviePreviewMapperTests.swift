//
//  MoviePreviewMapperTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
@testable import PopcornDiscoverAdapters
import Testing
import TMDb

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    private let mapper = MoviePreviewMapper()

    @Test("Maps all properties from TMDb MovieListItem to DiscoverDomain MoviePreview")
    func mapsAllProperties() throws {
        let posterPath = try #require(URL(string: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"))
        let backdropPath = try #require(URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"))
        let releaseDate = Date(timeIntervalSince1970: 939_686_400)

        let tmdbMovieListItem = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            genreIDs: [18, 53],
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 61.416,
            voteAverage: 8.433,
            voteCount: 27044,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovieListItem)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(
            result.overview == "A ticking-time-bomb insomniac and a slippery soap salesman..."
        )
        #expect(result.releaseDate == releaseDate)
        #expect(result.genreIDs == [18, 53])
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("Maps with nil release date uses current date")
    func mapsWithNilReleaseDateUsesCurrentDate() {
        let tmdbMovieListItem = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A movie overview",
            genreIDs: [18],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil,
            popularity: 10.0,
            voteAverage: 8.0,
            voteCount: 1000,
            hasVideo: false,
            isAdultOnly: false
        )

        let beforeMapping = Date()
        let result = mapper.map(tmdbMovieListItem)
        let afterMapping = Date()

        #expect(result.releaseDate >= beforeMapping)
        #expect(result.releaseDate <= afterMapping)
    }

    @Test("Maps with nil optional path properties")
    func mapsWithNilOptionalPathProperties() {
        let releaseDate = Date(timeIntervalSince1970: 939_686_400)

        let tmdbMovieListItem = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A movie overview",
            genreIDs: [18, 53],
            releaseDate: releaseDate,
            posterPath: nil,
            backdropPath: nil,
            popularity: 10.0,
            voteAverage: 8.0,
            voteCount: 1000,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovieListItem)

        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps with empty genre IDs array")
    func mapsWithEmptyGenreIDsArray() {
        let tmdbMovieListItem = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A movie overview",
            genreIDs: [],
            releaseDate: Date(),
            posterPath: nil,
            backdropPath: nil,
            popularity: 10.0,
            voteAverage: 8.0,
            voteCount: 1000,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovieListItem)

        #expect(result.genreIDs.isEmpty)
    }

    @Test("Maps empty overview correctly")
    func mapsEmptyOverviewCorrectly() {
        let tmdbMovieListItem = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "",
            genreIDs: [18],
            releaseDate: Date(),
            posterPath: nil,
            backdropPath: nil,
            popularity: 10.0,
            voteAverage: 8.0,
            voteCount: 1000,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovieListItem)

        #expect(result.overview == "")
    }

}
