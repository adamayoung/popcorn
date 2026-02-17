//
//  MovieMapperUpdateEntityTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import MoviesInfrastructure
import Testing

@Suite("MovieMapper Update Entity")
struct MovieMapperUpdateEntityTests {

    let mapper = MovieMapper()

    @Test("updates existing entity with core properties")
    func updatesExistingEntityWithCoreProperties() {
        let entity = MoviesMovieEntity(movieID: 123, title: "Old Title", overview: "Old Overview")

        mapper.map(Self.updatedMovie, to: entity)

        #expect(entity.title == "New Title")
        #expect(entity.tagline == "New Tagline")
        #expect(entity.originalTitle == "New Original Title")
        #expect(entity.originalLanguage == "fr")
        #expect(entity.overview == "New Overview")
        #expect(entity.runtime == 150)
        #expect(entity.releaseDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(entity.posterPath == URL(string: "https://example.com/new-poster.jpg"))
        #expect(entity.backdropPath == URL(string: "https://example.com/new-backdrop.jpg"))
        #expect(entity.budget == 200_000_000)
        #expect(entity.revenue == 800_000_000)
        #expect(entity.homepageURL == URL(string: "https://example.com/new-movie"))
        #expect(entity.imdbID == "tt9999999")
        #expect(entity.status == "postProduction")
        #expect(entity.originCountry == ["FR"])
        #expect(entity.popularity == 99.9)
        #expect(entity.voteAverage == 9.0)
        #expect(entity.voteCount == 5000)
        #expect(entity.hasVideo == false)
        #expect(entity.isAdultOnly == true)
    }

    @Test("updates existing entity with relationships")
    func updatesExistingEntityWithRelationships() {
        let entity = MoviesMovieEntity(movieID: 123, title: "Old Title", overview: "Old Overview")

        mapper.map(Self.updatedMovie, to: entity)

        #expect(entity.genres?.count == 1)
        #expect(entity.genres?[0].genreID == 35)
        #expect(entity.genres?[0].name == "Comedy")
        #expect(entity.productionCompanies?.count == 1)
        #expect(entity.productionCompanies?[0].companyID == 99)
        #expect(entity.productionCompanies?[0].name == "New Studio")
        #expect(entity.productionCountries?.count == 1)
        #expect(entity.productionCountries?[0].countryCode == "FR")
        #expect(entity.spokenLanguages?.count == 1)
        #expect(entity.spokenLanguages?[0].languageCode == "fr")
        #expect(entity.belongsToCollection?.collectionID == 200)
        #expect(entity.belongsToCollection?.name == "New Collection")
    }

    @Test("updates entity genres replacing existing ones")
    func updatesEntityGenresReplacingExistingOnes() {
        let entity = MoviesMovieEntity(
            movieID: 123,
            title: "Test Movie",
            overview: "Test Overview",
            genres: [
                MoviesGenreEntity(genreID: 28, name: "Action"),
                MoviesGenreEntity(genreID: 12, name: "Adventure")
            ]
        )

        let movie = Movie.mock(
            id: 123,
            title: "Test Movie",
            overview: "Test Overview",
            genres: [Genre(id: 35, name: "Comedy")]
        )

        mapper.map(movie, to: entity)

        #expect(entity.genres?.count == 1)
        #expect(entity.genres?[0].genreID == 35)
        #expect(entity.genres?[0].name == "Comedy")
    }

    @Test("updates entity with nil genres")
    func updatesEntityWithNilGenres() {
        let entity = MoviesMovieEntity(
            movieID: 123,
            title: "Test Movie",
            overview: "Test Overview",
            genres: [MoviesGenreEntity(genreID: 28, name: "Action")]
        )

        let movie = Movie.mock(id: 123, title: "Test Movie", overview: "Test Overview", genres: nil)

        mapper.map(movie, to: entity)

        #expect(entity.genres?.isEmpty == true)
    }

}

extension MovieMapperUpdateEntityTests {

    static let updatedMovie = Movie.mock(
        id: 123,
        title: "New Title",
        tagline: "New Tagline",
        originalTitle: "New Original Title",
        originalLanguage: "fr",
        overview: "New Overview",
        runtime: 150,
        genres: [Genre(id: 35, name: "Comedy")],
        releaseDate: Date(timeIntervalSince1970: 1_000_000),
        posterPath: URL(string: "https://example.com/new-poster.jpg"),
        backdropPath: URL(string: "https://example.com/new-backdrop.jpg"),
        budget: 200_000_000,
        revenue: 800_000_000,
        homepageURL: URL(string: "https://example.com/new-movie"),
        imdbID: "tt9999999",
        status: .postProduction,
        productionCompanies: [ProductionCompany(id: 99, name: "New Studio", originCountry: "FR")],
        productionCountries: [ProductionCountry(countryCode: "FR", name: "France")],
        spokenLanguages: [SpokenLanguage(languageCode: "fr", name: "French")],
        originCountry: ["FR"],
        belongsToCollection: MovieCollection(id: 200, name: "New Collection"),
        popularity: 99.9,
        voteAverage: 9.0,
        voteCount: 5000,
        hasVideo: false,
        isAdultOnly: true
    )

}
