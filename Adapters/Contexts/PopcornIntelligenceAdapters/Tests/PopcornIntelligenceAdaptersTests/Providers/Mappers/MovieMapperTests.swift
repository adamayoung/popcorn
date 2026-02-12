//
//  MovieMapperTests.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
import MoviesApplication
@testable import PopcornIntelligenceAdapters
import Testing

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps all properties from MovieDetails to IntelligenceDomain Movie")
    func mapsAllProperties() throws {
        let releaseDate = Date(timeIntervalSince1970: 939_686_400)
        let posterURLSet = try makeImageURLSet(path: "poster.jpg")
        let backdropURLSet = try makeImageURLSet(path: "backdrop.jpg")

        let movieDetails = MovieDetails(
            id: 550,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            runtime: 139,
            releaseDate: releaseDate,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            isOnWatchlist: false
        )

        let result = mapper.map(movieDetails)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "A ticking-time-bomb insomniac and a slippery soap salesman...")
        #expect(result.releaseDate == releaseDate)
        #expect(result.posterPath == posterURLSet.path)
        #expect(result.backdropPath == backdropURLSet.path)
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let movieDetails = MovieDetails(
            id: 550,
            title: "Fight Club",
            overview: "An overview",
            releaseDate: nil,
            posterURLSet: nil,
            backdropURLSet: nil,
            isOnWatchlist: true
        )

        let result = mapper.map(movieDetails)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "An overview")
        #expect(result.releaseDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps poster path correctly from URLSet")
    func mapsPosterPathFromURLSet() throws {
        let posterURLSet = try makeImageURLSet(path: "custom_poster.jpg")

        let movieDetails = MovieDetails(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            posterURLSet: posterURLSet,
            isOnWatchlist: false
        )

        let result = mapper.map(movieDetails)

        #expect(result.posterPath == posterURLSet.path)
    }

    @Test("Maps backdrop path correctly from URLSet")
    func mapsBackdropPathFromURLSet() throws {
        let backdropURLSet = try makeImageURLSet(path: "custom_backdrop.jpg")

        let movieDetails = MovieDetails(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            backdropURLSet: backdropURLSet,
            isOnWatchlist: false
        )

        let result = mapper.map(movieDetails)

        #expect(result.backdropPath == backdropURLSet.path)
    }

    @Test("Handles empty overview string")
    func handlesEmptyOverviewString() {
        let movieDetails = MovieDetails(
            id: 123,
            title: "Test Movie",
            overview: "",
            isOnWatchlist: false
        )

        let result = mapper.map(movieDetails)

        #expect(result.overview == "")
    }

}

// MARK: - Test Helpers

extension MovieMapperTests {

    private func makeImageURLSet(path: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/\(path)")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w342/\(path)")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/w500/\(path)")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)"))
        )
    }

}
