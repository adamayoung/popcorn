//
//  MovieMapperDomainToEntityTests.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
@testable import MoviesInfrastructure
import Testing

@Suite("MovieMapper Domain to Entity")
struct MovieMapperDomainToEntityTests {

    let mapper = MovieMapper()

    @Test("maps core properties from domain to entity")
    func mapsCorePropertiesFromDomainToEntity() {
        let entity = mapper.map(Self.fullMovie)

        #expect(entity.movieID == 123)
        #expect(entity.title == "Test Movie")
        #expect(entity.tagline == "Test Tagline")
        #expect(entity.originalTitle == "Original Title")
        #expect(entity.originalLanguage == "en")
        #expect(entity.overview == "Test Overview")
        #expect(entity.runtime == 120)
        #expect(entity.releaseDate == Date(timeIntervalSince1970: 0))
        #expect(entity.posterPath == URL(string: "https://example.com/poster.jpg"))
        #expect(entity.backdropPath == URL(string: "https://example.com/backdrop.jpg"))
        #expect(entity.budget == 100_000_000)
        #expect(entity.revenue == 500_000_000)
        #expect(entity.homepageURL == URL(string: "https://example.com/movie"))
        #expect(entity.imdbID == "tt1234567")
        #expect(entity.status == "released")
        #expect(entity.originCountry == ["US", "GB"])
        #expect(entity.popularity == 45.678)
        #expect(entity.voteAverage == 7.5)
        #expect(entity.voteCount == 1500)
        #expect(entity.hasVideo == true)
        #expect(entity.isAdultOnly == false)
    }

    @Test("maps relationships from domain to entity")
    func mapsRelationshipsFromDomainToEntity() {
        let entity = mapper.map(Self.fullMovie)

        #expect(entity.genres?.count == 2)
        #expect(entity.genres?[0].genreID == 28)
        #expect(entity.genres?[0].name == "Action")
        #expect(entity.genres?[1].genreID == 12)
        #expect(entity.genres?[1].name == "Adventure")
        #expect(entity.productionCompanies?.count == 1)
        #expect(entity.productionCompanies?[0].companyID == 25)
        #expect(entity.productionCompanies?[0].name == "20th Century Fox")
        #expect(entity.productionCompanies?[0].originCountry == "US")
        #expect(entity.productionCompanies?[0].logoPath == URL(string: "https://example.com/logo.png"))
        #expect(entity.productionCountries?.count == 1)
        #expect(entity.productionCountries?[0].countryCode == "US")
        #expect(entity.productionCountries?[0].name == "United States of America")
        #expect(entity.spokenLanguages?.count == 1)
        #expect(entity.spokenLanguages?[0].languageCode == "en")
        #expect(entity.spokenLanguages?[0].name == "English")
        #expect(entity.belongsToCollection?.collectionID == 119)
        #expect(entity.belongsToCollection?.name == "Test Collection")
    }

    @Test("maps nil core properties from domain to entity")
    func mapsNilCorePropertiesFromDomainToEntity() {
        let entity = mapper.map(Self.minimalMovie)

        #expect(entity.movieID == 456)
        #expect(entity.title == "Minimal Movie")
        #expect(entity.tagline == nil)
        #expect(entity.originalTitle == nil)
        #expect(entity.originalLanguage == nil)
        #expect(entity.overview == "Minimal Overview")
        #expect(entity.runtime == nil)
        #expect(entity.releaseDate == nil)
        #expect(entity.posterPath == nil)
        #expect(entity.backdropPath == nil)
        #expect(entity.budget == nil)
        #expect(entity.revenue == nil)
        #expect(entity.homepageURL == nil)
        #expect(entity.imdbID == nil)
        #expect(entity.status == nil)
        #expect(entity.originCountry == nil)
        #expect(entity.popularity == nil)
        #expect(entity.voteAverage == nil)
        #expect(entity.voteCount == nil)
        #expect(entity.hasVideo == nil)
        #expect(entity.isAdultOnly == nil)
    }

    @Test("maps nil relationships from domain to entity")
    func mapsNilRelationshipsFromDomainToEntity() {
        let entity = mapper.map(Self.minimalMovie)

        #expect(entity.genres == nil)
        #expect(entity.productionCompanies == nil)
        #expect(entity.productionCountries == nil)
        #expect(entity.spokenLanguages == nil)
        #expect(entity.belongsToCollection == nil)
    }

    @Test("maps with empty genres array from domain to entity")
    func mapsWithEmptyGenresArrayFromDomainToEntity() {
        let movie = Movie.mock(id: 789, title: "No Genres Movie", overview: "Overview", genres: [])

        let entity = mapper.map(movie)

        #expect(entity.genres != nil)
        #expect(entity.genres?.isEmpty == true)
    }

}

extension MovieMapperDomainToEntityTests {

    static let minimalMovie = Movie.mock(
        id: 456,
        title: "Minimal Movie",
        tagline: nil,
        originalTitle: nil,
        originalLanguage: nil,
        overview: "Minimal Overview",
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
        originCountry: nil,
        belongsToCollection: nil,
        popularity: nil,
        voteAverage: nil,
        voteCount: nil,
        hasVideo: nil,
        isAdultOnly: nil
    )

    static let fullMovie = Movie.mock(
        id: 123,
        title: "Test Movie",
        tagline: "Test Tagline",
        originalTitle: "Original Title",
        originalLanguage: "en",
        overview: "Test Overview",
        runtime: 120,
        genres: [
            Genre(id: 28, name: "Action"),
            Genre(id: 12, name: "Adventure")
        ],
        releaseDate: Date(timeIntervalSince1970: 0),
        posterPath: URL(string: "https://example.com/poster.jpg"),
        backdropPath: URL(string: "https://example.com/backdrop.jpg"),
        budget: 100_000_000,
        revenue: 500_000_000,
        homepageURL: URL(string: "https://example.com/movie"),
        imdbID: "tt1234567",
        status: .released,
        productionCompanies: [
            ProductionCompany(
                id: 25, name: "20th Century Fox", originCountry: "US",
                logoPath: URL(string: "https://example.com/logo.png")
            )
        ],
        productionCountries: [
            ProductionCountry(countryCode: "US", name: "United States of America")
        ],
        spokenLanguages: [
            SpokenLanguage(languageCode: "en", name: "English")
        ],
        originCountry: ["US", "GB"],
        belongsToCollection: MovieCollection(
            id: 119, name: "Test Collection",
            posterPath: URL(string: "https://example.com/collection-poster.jpg"),
            backdropPath: URL(string: "https://example.com/collection-backdrop.jpg")
        ),
        popularity: 45.678,
        voteAverage: 7.5,
        voteCount: 1500,
        hasVideo: true,
        isAdultOnly: false
    )

}
