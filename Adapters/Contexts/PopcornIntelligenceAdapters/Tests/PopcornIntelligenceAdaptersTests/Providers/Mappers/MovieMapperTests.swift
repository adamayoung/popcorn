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
import MoviesDomain
@testable import PopcornIntelligenceAdapters
import Testing

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps all properties from MovieDetails to IntelligenceDomain Movie")
    func mapsAllProperties() throws {
        let fixture = try makeFullMovieFixture()
        let result = mapper.map(fixture.movieDetails)
        assertFullMovieResult(result, fixture: fixture)
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
        #expect(result.tagline == nil)
        #expect(result.originalTitle == nil)
        #expect(result.originalLanguage == nil)
        #expect(result.runtime == nil)
        #expect(result.genres == nil)
        #expect(result.budget == nil)
        #expect(result.revenue == nil)
        #expect(result.homepageURL == nil)
        #expect(result.imdbID == nil)
        #expect(result.status == nil)
        #expect(result.productionCompanies == nil)
        #expect(result.productionCountries == nil)
        #expect(result.spokenLanguages == nil)
        #expect(result.originCountry == nil)
        #expect(result.belongsToCollection == nil)
        #expect(result.popularity == nil)
        #expect(result.voteAverage == nil)
        #expect(result.voteCount == nil)
        #expect(result.hasVideo == nil)
        #expect(result.isAdultOnly == nil)
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

    private struct FullMovieFixture {
        let movieDetails: MovieDetails
        let releaseDate: Date
        let posterURLSet: ImageURLSet
        let backdropURLSet: ImageURLSet
        let homepageURL: URL
        let genres: [Genre]
        let productionCompanies: [ProductionCompany]
        let productionCountries: [ProductionCountry]
        let spokenLanguages: [SpokenLanguage]
        let belongsToCollection: MovieCollection
    }

    private func makeImageURLSet(path: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/\(path)")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w342/\(path)")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/w500/\(path)")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)"))
        )
    }

    private func makeFullMovieFixture() throws -> FullMovieFixture {
        let basic = try makeBasicFixtureValues()
        let nested = try makeNestedFixtureValues()

        let movieDetails = MovieDetails(
            id: 550,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            originalTitle: "Fight Club Original",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
            runtime: 139,
            genres: nested.genres,
            releaseDate: basic.releaseDate,
            posterURLSet: basic.posterURLSet,
            backdropURLSet: basic.backdropURLSet,
            budget: 63_000_000,
            revenue: 100_853_753,
            homepageURL: basic.homepageURL,
            imdbID: "tt0137523",
            status: .released,
            productionCompanies: nested.productionCompanies,
            productionCountries: nested.productionCountries,
            spokenLanguages: nested.spokenLanguages,
            originCountry: ["US"],
            belongsToCollection: nested.belongsToCollection,
            popularity: 61.416,
            voteAverage: 8.4,
            voteCount: 28000,
            hasVideo: false,
            isAdultOnly: false,
            isOnWatchlist: false
        )

        return FullMovieFixture(
            movieDetails: movieDetails,
            releaseDate: basic.releaseDate,
            posterURLSet: basic.posterURLSet,
            backdropURLSet: basic.backdropURLSet,
            homepageURL: basic.homepageURL,
            genres: nested.genres,
            productionCompanies: nested.productionCompanies,
            productionCountries: nested.productionCountries,
            spokenLanguages: nested.spokenLanguages,
            belongsToCollection: nested.belongsToCollection
        )
    }

    private func makeBasicFixtureValues() throws -> (
        releaseDate: Date,
        posterURLSet: ImageURLSet,
        backdropURLSet: ImageURLSet,
        homepageURL: URL
    ) {
        try (
            releaseDate: Date(timeIntervalSince1970: 939_686_400),
            posterURLSet: makeImageURLSet(path: "poster.jpg"),
            backdropURLSet: makeImageURLSet(path: "backdrop.jpg"),
            homepageURL: #require(URL(string: "https://example.com/movie"))
        )
    }

    private func makeNestedFixtureValues() throws -> (
        genres: [Genre],
        productionCompanies: [ProductionCompany],
        productionCountries: [ProductionCountry],
        spokenLanguages: [SpokenLanguage],
        belongsToCollection: MovieCollection
    ) {
        let companyLogoURL = try #require(URL(string: "https://example.com/logo.png"))
        let collectionPosterURL = try #require(URL(string: "https://example.com/collection-poster.png"))
        let collectionBackdropURL = try #require(URL(string: "https://example.com/collection-backdrop.png"))

        let genres = [Genre(id: 18, name: "Drama")]
        let productionCompanies = [
            ProductionCompany(id: 508, name: "Regency Enterprises", originCountry: "US", logoPath: companyLogoURL)
        ]
        let productionCountries = [ProductionCountry(countryCode: "US", name: "United States of America")]
        let spokenLanguages = [SpokenLanguage(languageCode: "en", name: "English")]
        let belongsToCollection = MovieCollection(
            id: 100,
            name: "Collection",
            posterPath: collectionPosterURL,
            backdropPath: collectionBackdropURL
        )

        return (
            genres: genres,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: spokenLanguages,
            belongsToCollection: belongsToCollection
        )
    }

    private func assertFullMovieResult(_ result: Movie, fixture: FullMovieFixture) {
        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.tagline == "Mischief. Mayhem. Soap.")
        #expect(result.originalTitle == "Fight Club Original")
        #expect(result.originalLanguage == "en")
        #expect(result.overview == "A ticking-time-bomb insomniac and a slippery soap salesman...")
        #expect(result.runtime == 139)
        #expect(result.genres == fixture.genres)
        #expect(result.releaseDate == fixture.releaseDate)
        #expect(result.posterPath == fixture.posterURLSet.path)
        #expect(result.backdropPath == fixture.backdropURLSet.path)
        #expect(result.budget == 63_000_000)
        #expect(result.revenue == 100_853_753)
        #expect(result.homepageURL == fixture.homepageURL)
        #expect(result.imdbID == "tt0137523")
        #expect(result.status == .released)
        #expect(result.productionCompanies == fixture.productionCompanies)
        #expect(result.productionCountries == fixture.productionCountries)
        #expect(result.spokenLanguages == fixture.spokenLanguages)
        #expect(result.originCountry == ["US"])
        #expect(result.belongsToCollection == fixture.belongsToCollection)
        #expect(result.popularity == 61.416)
        #expect(result.voteAverage == 8.4)
        #expect(result.voteCount == 28000)
        #expect(result.hasVideo == false)
        #expect(result.isAdultOnly == false)
    }

}
