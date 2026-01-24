//
//  MovieMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import Testing
import TMDb

@testable import PopcornMoviesAdapters

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps all properties from TMDb Movie to MoviesDomain Movie")
    func mapsAllProperties() {
        let tmdbMovie = TMDb.Movie(
            id: 550,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            runtime: 139,
            genres: [
                TMDb.Genre(id: 18, name: "Drama"),
                TMDb.Genre(id: 53, name: "Thriller")
            ],
            releaseDate: Date(timeIntervalSince1970: 939_686_400), // 1999-10-12
            posterPath: URL(string: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
            backdropPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"),
            budget: 63_000_000,
            revenue: 100_853_753,
            homepageURL: URL(string: "http://www.foxmovies.com/movies/fight-club"),
            imdbID: "tt0137523",
            status: .released,
            productionCompanies: nil,
            productionCountries: nil,
            spokenLanguages: nil,
            popularity: 61.416,
            voteAverage: 8.433,
            voteCount: 27044,
            hasVideo: false,
            isAdultOnly: false
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.tagline == "Mischief. Mayhem. Soap.")
        #expect(result.overview == "A ticking-time-bomb insomniac and a slippery soap salesman...")
        #expect(result.runtime == 139)
        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].id == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].id == 53)
        #expect(result.genres?[1].name == "Thriller")
        #expect(result.releaseDate == Date(timeIntervalSince1970: 939_686_400))
        #expect(result.posterPath == URL(string: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"))
        #expect(result.backdropPath == URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"))
        #expect(result.budget == 63_000_000)
        #expect(result.revenue == 100_853_753)
        #expect(result.homepageURL == URL(string: "http://www.foxmovies.com/movies/fight-club"))
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let tmdbMovie = TMDb.Movie(
            id: 550,
            title: "Fight Club",
            tagline: nil,
            originalTitle: nil,
            originalLanguage: nil,
            overview: nil,
            runtime: nil,
            genres: nil,
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil,
            budget: nil,
            revenue: nil,
            homepageURL: nil,
            imdbID: nil,
            status: nil,
            productionCompanies: nil,
            productionCountries: nil,
            spokenLanguages: nil,
            popularity: nil,
            voteAverage: nil,
            voteCount: nil,
            hasVideo: nil,
            isAdultOnly: nil
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.tagline == nil)
        #expect(result.overview == "")
        #expect(result.runtime == nil)
        #expect(result.genres == nil)
        #expect(result.releaseDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
        #expect(result.budget == nil)
        #expect(result.revenue == nil)
        #expect(result.homepageURL == nil)
    }

    @Test("Maps with empty genres array")
    func mapsWithEmptyGenresArray() {
        let tmdbMovie = TMDb.Movie(
            id: 550,
            title: "Fight Club",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            genres: []
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.genres?.isEmpty == true)
    }

    @Test("Handles empty overview string")
    func handlesEmptyOverviewString() {
        let tmdbMovie = TMDb.Movie(
            id: 550,
            title: "Fight Club",
            overview: ""
        )

        let result = mapper.map(tmdbMovie)

        #expect(result.overview == "")
    }

}
