//
//  MovieMapperTests.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
@testable import MoviesInfrastructure
import Testing

@Suite("MovieMapper")
struct MovieMapperTests {

    let mapper = MovieMapper()

    // MARK: - Entity to Domain Tests

    @Test("maps core properties from entity to domain")
    func mapsCorePropertiesFromEntityToDomain() {
        let movie = mapper.map(Self.makeFullEntity())

        #expect(movie.id == 123)
        #expect(movie.title == "Test Movie")
        #expect(movie.tagline == "Test Tagline")
        #expect(movie.originalTitle == "Original Title")
        #expect(movie.originalLanguage == "en")
        #expect(movie.overview == "Test Overview")
        #expect(movie.runtime == 120)
        #expect(movie.releaseDate == Date(timeIntervalSince1970: 0))
        #expect(movie.posterPath == URL(string: "https://example.com/poster.jpg"))
        #expect(movie.backdropPath == URL(string: "https://example.com/backdrop.jpg"))
        #expect(movie.budget == 100_000_000)
        #expect(movie.revenue == 500_000_000)
        #expect(movie.homepageURL == URL(string: "https://example.com/movie"))
        #expect(movie.imdbID == "tt1234567")
        #expect(movie.status == .released)
        #expect(movie.originCountry == ["US", "GB"])
        #expect(movie.popularity == 45.678)
        #expect(movie.voteAverage == 7.5)
        #expect(movie.voteCount == 1500)
        #expect(movie.hasVideo == true)
        #expect(movie.isAdultOnly == false)
    }

    @Test("maps relationships from entity to domain")
    func mapsRelationshipsFromEntityToDomain() {
        let movie = mapper.map(Self.makeFullEntity())

        #expect(movie.genres?.count == 2)
        #expect(movie.genres?[0].id == 28)
        #expect(movie.genres?[0].name == "Action")
        #expect(movie.genres?[1].id == 12)
        #expect(movie.genres?[1].name == "Adventure")
        #expect(movie.productionCompanies?.count == 1)
        #expect(movie.productionCompanies?[0].id == 25)
        #expect(movie.productionCompanies?[0].name == "20th Century Fox")
        #expect(movie.productionCompanies?[0].originCountry == "US")
        #expect(movie.productionCompanies?[0].logoPath == URL(string: "https://example.com/logo.png"))
        #expect(movie.productionCountries?.count == 1)
        #expect(movie.productionCountries?[0].countryCode == "US")
        #expect(movie.productionCountries?[0].name == "United States of America")
        #expect(movie.spokenLanguages?.count == 1)
        #expect(movie.spokenLanguages?[0].languageCode == "en")
        #expect(movie.spokenLanguages?[0].name == "English")
        #expect(movie.belongsToCollection?.id == 119)
        #expect(movie.belongsToCollection?.name == "Test Collection")
    }

    @Test("maps with nil optional properties from entity to domain")
    func mapsWithNilOptionalPropertiesFromEntityToDomain() {
        let entity = MoviesMovieEntity(movieID: 456, title: "Minimal Movie", overview: "Minimal Overview")

        let movie = mapper.map(entity)

        #expect(movie.id == 456)
        #expect(movie.title == "Minimal Movie")
        #expect(movie.tagline == nil)
        #expect(movie.originalTitle == nil)
        #expect(movie.originalLanguage == nil)
        #expect(movie.overview == "Minimal Overview")
        #expect(movie.runtime == nil)
        #expect(movie.releaseDate == nil)
        #expect(movie.posterPath == nil)
        #expect(movie.backdropPath == nil)
        #expect(movie.budget == nil)
        #expect(movie.revenue == nil)
        #expect(movie.homepageURL == nil)
        #expect(movie.imdbID == nil)
        #expect(movie.status == nil)
        #expect(movie.originCountry == nil)
        #expect(movie.popularity == nil)
        #expect(movie.voteAverage == nil)
        #expect(movie.voteCount == nil)
        #expect(movie.hasVideo == nil)
        #expect(movie.isAdultOnly == nil)
        #expect(movie.genres == nil)
        #expect(movie.productionCompanies == nil)
        #expect(movie.productionCountries == nil)
        #expect(movie.spokenLanguages == nil)
        #expect(movie.belongsToCollection == nil)
    }

    @Test("maps with empty genres array from entity to domain")
    func mapsWithEmptyGenresArrayFromEntityToDomain() {
        let entity = MoviesMovieEntity(movieID: 789, title: "No Genres Movie", overview: "Overview", genres: [])

        let movie = mapper.map(entity)

        #expect(movie.genres != nil)
        #expect(movie.genres?.isEmpty == true)
    }

    // MARK: - CompactMap Tests

    @Test("compactMap returns movie when entity is not nil")
    func compactMapReturnMovieWhenEntityIsNotNil() {
        let entity = MoviesMovieEntity(movieID: 123, title: "Test Movie", overview: "Test Overview")

        let movie = mapper.compactMap(entity)

        #expect(movie != nil)
        #expect(movie?.id == 123)
        #expect(movie?.title == "Test Movie")
    }

    @Test("compactMap returns nil when entity is nil")
    func compactMapReturnsNilWhenEntityIsNil() {
        let movie = mapper.compactMap(nil)

        #expect(movie == nil)
    }

}

extension MovieMapperTests {

    static func makeFullEntity() -> MoviesMovieEntity {
        MoviesMovieEntity(
            movieID: 123,
            title: "Test Movie",
            tagline: "Test Tagline",
            originalTitle: "Original Title",
            originalLanguage: "en",
            overview: "Test Overview",
            runtime: 120,
            releaseDate: Date(timeIntervalSince1970: 0),
            posterPath: URL(string: "https://example.com/poster.jpg"),
            backdropPath: URL(string: "https://example.com/backdrop.jpg"),
            budget: 100_000_000,
            revenue: 500_000_000,
            homepageURL: URL(string: "https://example.com/movie"),
            imdbID: "tt1234567",
            status: "released",
            originCountry: ["US", "GB"],
            popularity: 45.678,
            voteAverage: 7.5,
            voteCount: 1500,
            hasVideo: true,
            isAdultOnly: false,
            genres: [
                MoviesGenreEntity(genreID: 28, name: "Action"),
                MoviesGenreEntity(genreID: 12, name: "Adventure")
            ],
            productionCompanies: [
                MoviesProductionCompanyEntity(
                    companyID: 25, name: "20th Century Fox", originCountry: "US",
                    logoPath: URL(string: "https://example.com/logo.png")
                )
            ],
            productionCountries: [
                MoviesProductionCountryEntity(countryCode: "US", name: "United States of America")
            ],
            spokenLanguages: [
                MoviesSpokenLanguageEntity(languageCode: "en", name: "English")
            ],
            belongsToCollection: MoviesMovieCollectionEntity(
                collectionID: 119, name: "Test Collection",
                posterPath: URL(string: "https://example.com/collection-poster.jpg"),
                backdropPath: URL(string: "https://example.com/collection-backdrop.jpg")
            )
        )
    }

}
