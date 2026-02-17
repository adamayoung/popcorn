//
//  MovieTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import IntelligenceDomain
import MoviesDomain
import Testing

@Suite("IntelligenceDomain.Movie Tests")
struct MovieTests {

    @Test("Initializes with all properties")
    func initializesWithAllProperties() throws {
        let fixture = try makeFullMovieFixture()
        assertFullMovie(fixture.movie, fixture: fixture)
    }

    @Test("Optional properties default to nil")
    func optionalPropertiesDefaultToNil() {
        let movie = IntelligenceDomain.Movie(
            id: 1,
            title: "Title",
            overview: "Overview"
        )

        #expect(movie.tagline == nil)
        #expect(movie.originalTitle == nil)
        #expect(movie.originalLanguage == nil)
        #expect(movie.runtime == nil)
        #expect(movie.genres == nil)
        #expect(movie.releaseDate == nil)
        #expect(movie.posterPath == nil)
        #expect(movie.backdropPath == nil)
        #expect(movie.budget == nil)
        #expect(movie.revenue == nil)
        #expect(movie.homepageURL == nil)
        #expect(movie.imdbID == nil)
        #expect(movie.status == nil)
        #expect(movie.productionCompanies == nil)
        #expect(movie.productionCountries == nil)
        #expect(movie.spokenLanguages == nil)
        #expect(movie.originCountry == nil)
        #expect(movie.belongsToCollection == nil)
        #expect(movie.popularity == nil)
        #expect(movie.voteAverage == nil)
        #expect(movie.voteCount == nil)
        #expect(movie.hasVideo == nil)
        #expect(movie.isAdultOnly == nil)
    }
}

// MARK: - Test Helpers

extension MovieTests {

    private struct FullMovieFixture {
        let movie: IntelligenceDomain.Movie
        let releaseDate: Date
        let posterPath: URL
        let backdropPath: URL
        let homepageURL: URL
        let genres: [Genre]
        let productionCompanies: [ProductionCompany]
        let productionCountries: [ProductionCountry]
        let spokenLanguages: [SpokenLanguage]
        let belongsToCollection: MovieCollection
    }

    private func makeFullMovieFixture() throws -> FullMovieFixture {
        let basic = try makeBasicFixtureValues()
        let nested = try makeNestedFixtureValues()

        let movie = IntelligenceDomain.Movie(
            id: 550,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            originalTitle: "Fight Club Original",
            originalLanguage: "en",
            overview: "An insomniac and a soap salesman form an underground club.",
            runtime: 139,
            genres: nested.genres,
            releaseDate: basic.releaseDate,
            posterPath: basic.posterPath,
            backdropPath: basic.backdropPath,
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
            isAdultOnly: false
        )

        return FullMovieFixture(
            movie: movie,
            releaseDate: basic.releaseDate,
            posterPath: basic.posterPath,
            backdropPath: basic.backdropPath,
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
        posterPath: URL,
        backdropPath: URL,
        homepageURL: URL
    ) {
        try (
            releaseDate: Date(timeIntervalSince1970: 939_686_400),
            posterPath: #require(URL(string: "https://image.tmdb.org/t/p/original/poster.jpg")),
            backdropPath: #require(URL(string: "https://image.tmdb.org/t/p/original/backdrop.jpg")),
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
        let companyLogoPath = try #require(URL(string: "https://example.com/logo.png"))
        let collectionPosterPath = try #require(URL(string: "https://example.com/collection-poster.png"))
        let collectionBackdropPath = try #require(URL(string: "https://example.com/collection-backdrop.png"))

        let genres = [Genre(id: 1, name: "Action")]
        let productionCompanies = [
            ProductionCompany(id: 2, name: "Studio", originCountry: "US", logoPath: companyLogoPath)
        ]
        let productionCountries = [ProductionCountry(countryCode: "US", name: "United States")]
        let spokenLanguages = [SpokenLanguage(languageCode: "en", name: "English")]
        let belongsToCollection = MovieCollection(
            id: 3,
            name: "Collection",
            posterPath: collectionPosterPath,
            backdropPath: collectionBackdropPath
        )

        return (
            genres: genres,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: spokenLanguages,
            belongsToCollection: belongsToCollection
        )
    }

    private func assertFullMovie(_ movie: IntelligenceDomain.Movie, fixture: FullMovieFixture) {
        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
        #expect(movie.tagline == "Mischief. Mayhem. Soap.")
        #expect(movie.originalTitle == "Fight Club Original")
        #expect(movie.originalLanguage == "en")
        #expect(movie.overview == "An insomniac and a soap salesman form an underground club.")
        #expect(movie.runtime == 139)
        #expect(movie.genres == fixture.genres)
        #expect(movie.releaseDate == fixture.releaseDate)
        #expect(movie.posterPath == fixture.posterPath)
        #expect(movie.backdropPath == fixture.backdropPath)
        #expect(movie.budget == 63_000_000)
        #expect(movie.revenue == 100_853_753)
        #expect(movie.homepageURL == fixture.homepageURL)
        #expect(movie.imdbID == "tt0137523")
        #expect(movie.status == .released)
        #expect(movie.productionCompanies == fixture.productionCompanies)
        #expect(movie.productionCountries == fixture.productionCountries)
        #expect(movie.spokenLanguages == fixture.spokenLanguages)
        #expect(movie.originCountry == ["US"])
        #expect(movie.belongsToCollection == fixture.belongsToCollection)
        #expect(movie.popularity == 61.416)
        #expect(movie.voteAverage == 8.4)
        #expect(movie.voteCount == 28000)
        #expect(movie.hasVideo == false)
        #expect(movie.isAdultOnly == false)
    }
}
