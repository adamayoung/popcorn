//
//  MovieMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps core properties from TMDb Movie to MoviesDomain Movie")
    func mapsCoreProperties() {
        let result = mapper.map(Self.fullTMDbMovie)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.tagline == "Mischief. Mayhem. Soap.")
        #expect(result.originalTitle == "Fight Club")
        #expect(result.originalLanguage == "en")
        #expect(result.originCountry == ["US"])
        #expect(result.overview == "A ticking-time-bomb insomniac and a slippery soap salesman...")
        #expect(result.runtime == 139)
        #expect(result.releaseDate == Date(timeIntervalSince1970: 939_686_400))
        #expect(result.posterPath == URL(string: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"))
        #expect(result.backdropPath == URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"))
        #expect(result.budget == 63_000_000)
        #expect(result.revenue == 100_853_753)
        #expect(result.homepageURL == URL(string: "http://www.foxmovies.com/movies/fight-club"))
        #expect(result.imdbID == "tt0137523")
        #expect(result.status == .released)
    }

    @Test("Maps genres from TMDb Movie to MoviesDomain Movie")
    func mapsGenres() {
        let result = mapper.map(Self.fullTMDbMovie)

        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].id == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].id == 53)
        #expect(result.genres?[1].name == "Thriller")
    }

    @Test("Maps production and metadata properties from TMDb Movie")
    func mapsProductionAndMetadataProperties() {
        let result = mapper.map(Self.fullTMDbMovie)

        #expect(result.productionCompanies?.count == 1)
        #expect(result.productionCompanies?[0].id == 508)
        #expect(result.productionCompanies?[0].name == "Regency Enterprises")
        #expect(result.productionCountries?.count == 1)
        #expect(result.productionCountries?[0].countryCode == "US")
        #expect(result.productionCountries?[0].name == "United States of America")
        #expect(result.spokenLanguages?.count == 1)
        #expect(result.spokenLanguages?[0].languageCode == "en")
        #expect(result.spokenLanguages?[0].name == "English")
        #expect(result.belongsToCollection?.id == 1234)
        #expect(result.belongsToCollection?.name == "Fight Club Collection")
        #expect(result.belongsToCollection?.posterPath == URL(string: "/collection-poster.jpg"))
        #expect(result.belongsToCollection?.backdropPath == URL(string: "/collection-backdrop.jpg"))
        #expect(result.popularity == 61.416)
        #expect(result.voteAverage == 8.433)
        #expect(result.voteCount == 27044)
        #expect(result.hasVideo == false)
        #expect(result.isAdultOnly == false)
    }

    @Test("Maps with nil optional properties")
    func mapsWithNilOptionalProperties() {
        let tmdbMovie = TMDb.Movie(id: 550, title: "Fight Club")

        let result = mapper.map(tmdbMovie)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.tagline == nil)
        #expect(result.originalTitle == nil)
        #expect(result.originalLanguage == nil)
        #expect(result.originCountry == nil)
        #expect(result.overview == "")
        #expect(result.runtime == nil)
        #expect(result.genres == nil)
        #expect(result.releaseDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
        #expect(result.budget == nil)
        #expect(result.revenue == nil)
        #expect(result.homepageURL == nil)
        #expect(result.imdbID == nil)
        #expect(result.status == nil)
        #expect(result.productionCompanies == nil)
        #expect(result.productionCountries == nil)
        #expect(result.spokenLanguages == nil)
        #expect(result.belongsToCollection == nil)
        #expect(result.popularity == nil)
        #expect(result.voteAverage == nil)
        #expect(result.voteCount == nil)
        #expect(result.hasVideo == nil)
        #expect(result.isAdultOnly == nil)
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
        let tmdbMovie = TMDb.Movie(id: 550, title: "Fight Club", overview: "")

        let result = mapper.map(tmdbMovie)

        #expect(result.overview == "")
    }

}

extension MovieMapperTests {

    private static let fullTMDbMovie = TMDb.Movie(
        id: 550,
        title: "Fight Club",
        tagline: "Mischief. Mayhem. Soap.",
        originalTitle: "Fight Club",
        originalLanguage: "en",
        originCountry: ["US"],
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman...",
        runtime: 139,
        genres: [
            TMDb.Genre(id: 18, name: "Drama"),
            TMDb.Genre(id: 53, name: "Thriller")
        ],
        releaseDate: Date(timeIntervalSince1970: 939_686_400),
        posterPath: URL(string: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
        backdropPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"),
        budget: 63_000_000,
        revenue: 100_853_753,
        homepageURL: URL(string: "http://www.foxmovies.com/movies/fight-club"),
        imdbID: "tt0137523",
        status: .released,
        productionCompanies: [
            TMDb.ProductionCompany(id: 508, name: "Regency Enterprises", originCountry: "US", logoPath: nil)
        ],
        productionCountries: [
            TMDb.ProductionCountry(countryCode: "US", name: "United States of America")
        ],
        spokenLanguages: [
            TMDb.SpokenLanguage(languageCode: "en", name: "English")
        ],
        belongsToCollection: TMDb.BelongsToCollection(
            id: 1234,
            name: "Fight Club Collection",
            posterPath: URL(string: "/collection-poster.jpg"),
            backdropPath: URL(string: "/collection-backdrop.jpg")
        ),
        popularity: 61.416,
        voteAverage: 8.433,
        voteCount: 27044,
        hasVideo: false,
        isAdultOnly: false
    )

}
