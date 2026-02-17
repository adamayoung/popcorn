//
//  MovieToolMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
@testable import IntelligenceInfrastructure
import Testing

@Suite("MovieToolMapper")
struct MovieToolMapperTests {

    let mapper = MovieToolMapper()

    @Test("map returns all movie properties")
    func mapReturnsAllMovieProperties() throws {
        let fixture = try makeFullMovieFixture()
        let result = mapper.map(fixture.movie)
        assertFullMovieResult(result)
    }

    @Test("map returns nil for absent optional properties")
    func mapReturnsNilForAbsentOptionalProperties() {
        let movie = IntelligenceDomain.Movie(
            id: 1,
            title: "Untitled",
            overview: "Overview"
        )

        let result = mapper.map(movie)

        #expect(result.tagline == nil)
        #expect(result.originalTitle == nil)
        #expect(result.originalLanguage == nil)
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
        #expect(result.originCountry == nil)
        #expect(result.belongsToCollection == nil)
        #expect(result.popularity == nil)
        #expect(result.voteAverage == nil)
        #expect(result.voteCount == nil)
        #expect(result.hasVideo == nil)
        #expect(result.isAdultOnly == nil)
    }

}

// MARK: - Test Helpers

extension MovieToolMapperTests {

    private struct FullMovieFixture {
        let movie: IntelligenceDomain.Movie
    }

    private func makeFullMovieFixture() throws -> FullMovieFixture {
        let releaseDate = Date(timeIntervalSince1970: 1_609_459_200)
        let posterPath = try #require(URL(string: "https://image.tmdb.org/t/p/original/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://image.tmdb.org/t/p/original/backdrop.jpg"))
        let homepageURL = try #require(URL(string: "https://example.com/movie"))

        let movie = IntelligenceDomain.Movie(
            id: 123,
            title: "The Matrix",
            tagline: "Welcome to the Real World.",
            originalTitle: "The Matrix Original",
            originalLanguage: "en",
            overview: "A computer hacker learns about the true nature of reality",
            runtime: 136,
            genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Science Fiction")],
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            budget: 63_000_000,
            revenue: 467_200_000,
            homepageURL: homepageURL,
            imdbID: "tt0133093",
            status: .released,
            productionCompanies: [
                ProductionCompany(id: 4, name: "Warner Bros.", originCountry: "US")
            ],
            productionCountries: [ProductionCountry(countryCode: "US", name: "United States")],
            spokenLanguages: [SpokenLanguage(languageCode: "en", name: "English")],
            originCountry: ["US"],
            belongsToCollection: MovieCollection(id: 5, name: "The Matrix Collection"),
            popularity: 82.5,
            voteAverage: 8.7,
            voteCount: 24500,
            hasVideo: false,
            isAdultOnly: false
        )

        return FullMovieFixture(movie: movie)
    }

    private func assertFullMovieResult(_ result: MovieToolMovie) {
        #expect(result.id == 123)
        #expect(result.title == "The Matrix")
        #expect(result.tagline == "Welcome to the Real World.")
        #expect(result.originalTitle == "The Matrix Original")
        #expect(result.originalLanguage == "en")
        #expect(result.overview == "A computer hacker learns about the true nature of reality")
        #expect(result.runtime == 136)
        #expect(result.genres == [
            .init(id: 1, name: "Action"),
            .init(id: 2, name: "Science Fiction")
        ])
        #expect(result.releaseDate != nil)
        #expect(result.posterPath == "https://image.tmdb.org/t/p/original/poster.jpg")
        #expect(result.backdropPath == "https://image.tmdb.org/t/p/original/backdrop.jpg")
        #expect(result.budget == 63_000_000)
        #expect(result.revenue == 467_200_000)
        #expect(result.homepageURL == "https://example.com/movie")
        #expect(result.imdbID == "tt0133093")
        #expect(result.status == "released")
        #expect(result.productionCompanies == [
            .init(id: 4, name: "Warner Bros.", originCountry: "US")
        ])
        #expect(result.productionCountries == [.init(countryCode: "US", name: "United States")])
        #expect(result.spokenLanguages == [.init(languageCode: "en", name: "English")])
        #expect(result.originCountry == ["US"])
        #expect(result.belongsToCollection == .init(id: 5, name: "The Matrix Collection"))
        #expect(result.popularity == 82.5)
        #expect(result.voteAverage == 8.7)
        #expect(result.voteCount == 24500)
        #expect(result.hasVideo == false)
        #expect(result.isAdultOnly == false)
    }
}
