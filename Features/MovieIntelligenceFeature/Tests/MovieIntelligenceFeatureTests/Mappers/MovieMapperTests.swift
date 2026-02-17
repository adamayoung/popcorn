//
//  MovieMapperTests.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
@testable import MovieIntelligenceFeature
import MoviesApplication
import MoviesDomain
import Testing

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps core text properties from MovieDetails to Movie")
    func mapsCoreTextProperties() throws {
        let details = try makeFullDetails()
        let result = mapper.map(details)

        #expect(result.id == 798_645)
        #expect(result.title == "The Running Man")
        #expect(result.tagline == "The race for survival begins.")
        #expect(result.originalTitle == "The Running Man")
        #expect(result.originalLanguage == "en")
        #expect(result.overview == "A thrilling action movie.")
        #expect(result.runtime == 120)
        #expect(result.imdbID == "tt0093894")
        #expect(result.hasVideo == false)
        #expect(result.isAdultOnly == false)
    }

    @Test("Maps numeric and URL properties from MovieDetails to Movie")
    func mapsNumericAndURLProperties() throws {
        let (details, posterURL, backdropURL, homepageURL, releaseDate) = try makeFullDetailsWithURLs()
        let result = mapper.map(details)

        #expect(result.releaseDate == releaseDate)
        #expect(result.posterPath == posterURL)
        #expect(result.backdropPath == backdropURL)
        #expect(result.budget == 100_000_000)
        #expect(result.revenue == 250_000_000)
        #expect(result.homepageURL == homepageURL)
        #expect(result.popularity == 42.5)
        #expect(result.voteAverage == 6.7)
        #expect(result.voteCount == 1234)
    }

    @Test("Maps genres from MovieDetails to Movie")
    func mapsGenres() {
        let details = MovieDetails(
            id: 1,
            title: "Action Movie",
            overview: "",
            genres: [
                MoviesDomain.Genre(id: 28, name: "Action"),
                MoviesDomain.Genre(id: 12, name: "Adventure")
            ],
            isOnWatchlist: false
        )

        let result = mapper.map(details)

        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].id == 28)
        #expect(result.genres?[0].name == "Action")
        #expect(result.genres?[1].id == 12)
        #expect(result.genres?[1].name == "Adventure")
    }

    @Test("Maps all MovieStatus values")
    func mapsAllStatuses() {
        let cases: [(MoviesDomain.MovieStatus, IntelligenceDomain.MovieStatus)] = [
            (.rumoured, .rumoured), (.planned, .planned), (.inProduction, .inProduction),
            (.postProduction, .postProduction), (.released, .released), (.cancelled, .cancelled)
        ]
        for (input, expected) in cases {
            let details = MovieDetails(id: 1, title: "M", overview: "", status: input, isOnWatchlist: false)
            #expect(mapper.map(details).status == expected)
        }
    }

    @Test("Maps production metadata from MovieDetails to Movie")
    func mapsProductionMetadata() {
        let details = MovieDetails(
            id: 550,
            title: "Fight Club",
            overview: "",
            productionCompanies: [MoviesDomain.ProductionCompany(id: 4, name: "TriStar", originCountry: "US")],
            productionCountries: [MoviesDomain.ProductionCountry(countryCode: "US", name: "United States")],
            spokenLanguages: [MoviesDomain.SpokenLanguage(languageCode: "en", name: "English")],
            originCountry: ["US"],
            belongsToCollection: MoviesDomain.MovieCollection(id: 5, name: "The Matrix Collection"),
            isOnWatchlist: false
        )
        let result = mapper.map(details)

        #expect(result.productionCompanies?.first?.id == 4)
        #expect(result.productionCountries?.first?.countryCode == "US")
        #expect(result.spokenLanguages?.first?.languageCode == "en")
        #expect(result.originCountry == ["US"])
        #expect(result.belongsToCollection?.id == 5)
        #expect(result.belongsToCollection?.name == "The Matrix Collection")
    }

    @Test("Maps nil optional properties")
    func mapsNilOptionalProperties() {
        let result = mapper.map(MovieDetails(id: 1, title: "Minimal", overview: "", isOnWatchlist: false))

        #expect(result.tagline == nil)
        #expect(result.genres == nil)
        #expect(result.releaseDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
        #expect(result.status == nil)
        #expect(result.productionCompanies == nil)
        #expect(result.productionCountries == nil)
        #expect(result.spokenLanguages == nil)
        #expect(result.originCountry == nil)
        #expect(result.belongsToCollection == nil)
    }

    @Test("Maps multiple movies correctly")
    func mapsMultipleMovies() {
        let details1 = MovieDetails(id: 1, title: "Movie 1", overview: "", isOnWatchlist: false)
        let details2 = MovieDetails(id: 2, title: "Movie 2", overview: "", isOnWatchlist: false)
        let results = [details1, details2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[1].id == 2)
    }

}

// MARK: - Helpers

extension MovieMapperTests {

    private func makeImageURLSet(suffix: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://image.tmdb.org/t/p/original/\(suffix)")),
            thumbnail: #require(URL(string: "https://example.com/thumb/\(suffix)")),
            card: #require(URL(string: "https://example.com/card/\(suffix)")),
            detail: #require(URL(string: "https://example.com/detail/\(suffix)")),
            full: #require(URL(string: "https://example.com/full/\(suffix)"))
        )
    }

    private func makeFullDetails() throws -> MovieDetails {
        let (details, _, _, _, _) = try makeFullDetailsWithURLs()
        return details
    }

    private func makeFullDetailsWithURLs() throws -> (
        MovieDetails, posterURL: URL, backdropURL: URL, homepageURL: URL, releaseDate: Date
    ) {
        let posterURL = try #require(URL(string: "https://image.tmdb.org/t/p/original/poster.jpg"))
        let backdropURL = try #require(URL(string: "https://image.tmdb.org/t/p/original/backdrop.jpg"))
        let homepageURL = try #require(URL(string: "https://example.com/movie"))
        let releaseDate = Date(timeIntervalSinceReferenceDate: 0)

        let details = try MovieDetails(
            id: 798_645,
            title: "The Running Man",
            tagline: "The race for survival begins.",
            originalTitle: "The Running Man",
            originalLanguage: "en",
            overview: "A thrilling action movie.",
            runtime: 120,
            releaseDate: releaseDate,
            posterURLSet: makeImageURLSet(suffix: "poster.jpg"),
            backdropURLSet: makeImageURLSet(suffix: "backdrop.jpg"),
            budget: 100_000_000,
            revenue: 250_000_000,
            homepageURL: homepageURL,
            imdbID: "tt0093894",
            popularity: 42.5,
            voteAverage: 6.7,
            voteCount: 1234,
            hasVideo: false,
            isAdultOnly: false,
            isOnWatchlist: false
        )

        return (details, posterURL, backdropURL, homepageURL, releaseDate)
    }

}
