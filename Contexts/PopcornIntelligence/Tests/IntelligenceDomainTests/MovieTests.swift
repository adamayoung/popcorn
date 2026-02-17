//
//  MovieTests.swift
//  PopcornIntelligence
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import IntelligenceDomain
import MoviesDomain
import Testing

@Suite("IntelligenceDomain.Movie Tests")
struct MovieTests {

    @Test("Initializes with all properties")
    func initializesWithAllProperties() throws {
        let releaseDate = Date(timeIntervalSince1970: 939_686_400)
        let posterPath = try #require(URL(string: "https://image.tmdb.org/t/p/original/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://image.tmdb.org/t/p/original/backdrop.jpg"))
        let homepageURL = try #require(URL(string: "https://example.com/movie"))
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

        let movie = IntelligenceDomain.Movie(
            id: 550,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            originalTitle: "Fight Club Original",
            originalLanguage: "en",
            overview: "An insomniac and a soap salesman form an underground club.",
            runtime: 139,
            genres: genres,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            budget: 63_000_000,
            revenue: 100_853_753,
            homepageURL: homepageURL,
            imdbID: "tt0137523",
            status: .released,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: spokenLanguages,
            originCountry: ["US"],
            belongsToCollection: belongsToCollection,
            popularity: 61.416,
            voteAverage: 8.4,
            voteCount: 28_000,
            hasVideo: false,
            isAdultOnly: false
        )

        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
        #expect(movie.tagline == "Mischief. Mayhem. Soap.")
        #expect(movie.originalTitle == "Fight Club Original")
        #expect(movie.originalLanguage == "en")
        #expect(movie.overview == "An insomniac and a soap salesman form an underground club.")
        #expect(movie.runtime == 139)
        #expect(movie.genres == genres)
        #expect(movie.releaseDate == releaseDate)
        #expect(movie.posterPath == posterPath)
        #expect(movie.backdropPath == backdropPath)
        #expect(movie.budget == 63_000_000)
        #expect(movie.revenue == 100_853_753)
        #expect(movie.homepageURL == homepageURL)
        #expect(movie.imdbID == "tt0137523")
        #expect(movie.status == .released)
        #expect(movie.productionCompanies == productionCompanies)
        #expect(movie.productionCountries == productionCountries)
        #expect(movie.spokenLanguages == spokenLanguages)
        #expect(movie.originCountry == ["US"])
        #expect(movie.belongsToCollection == belongsToCollection)
        #expect(movie.popularity == 61.416)
        #expect(movie.voteAverage == 8.4)
        #expect(movie.voteCount == 28_000)
        #expect(movie.hasVideo == false)
        #expect(movie.isAdultOnly == false)
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
