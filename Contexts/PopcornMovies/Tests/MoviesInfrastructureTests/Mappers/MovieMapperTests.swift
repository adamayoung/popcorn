//
//  MovieMapperTests.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import Testing

@testable import MoviesInfrastructure

@Suite("MovieMapper")
struct MovieMapperTests {

    let mapper = MovieMapper()

    // MARK: - Entity to Domain Tests

    @Test("maps all properties from entity to domain")
    func mapsAllPropertiesFromEntityToDomain() {
        let entity = MoviesMovieEntity(
            movieID: 123,
            title: "Test Movie",
            tagline: "Test Tagline",
            overview: "Test Overview",
            runtime: 120,
            releaseDate: Date(timeIntervalSince1970: 0),
            posterPath: URL(string: "https://example.com/poster.jpg"),
            backdropPath: URL(string: "https://example.com/backdrop.jpg"),
            budget: 100_000_000,
            revenue: 500_000_000,
            homepageURL: URL(string: "https://example.com/movie"),
            genres: [
                MoviesGenreEntity(genreID: 28, name: "Action"),
                MoviesGenreEntity(genreID: 12, name: "Adventure")
            ]
        )

        let movie = mapper.map(entity)

        #expect(movie.id == 123)
        #expect(movie.title == "Test Movie")
        #expect(movie.tagline == "Test Tagline")
        #expect(movie.overview == "Test Overview")
        #expect(movie.runtime == 120)
        #expect(movie.releaseDate == Date(timeIntervalSince1970: 0))
        #expect(movie.posterPath == URL(string: "https://example.com/poster.jpg"))
        #expect(movie.backdropPath == URL(string: "https://example.com/backdrop.jpg"))
        #expect(movie.budget == 100_000_000)
        #expect(movie.revenue == 500_000_000)
        #expect(movie.homepageURL == URL(string: "https://example.com/movie"))
        #expect(movie.genres?.count == 2)
        #expect(movie.genres?[0].id == 28)
        #expect(movie.genres?[0].name == "Action")
        #expect(movie.genres?[1].id == 12)
        #expect(movie.genres?[1].name == "Adventure")
    }

    @Test("maps with nil optional properties from entity to domain")
    func mapsWithNilOptionalPropertiesFromEntityToDomain() {
        let entity = MoviesMovieEntity(
            movieID: 456,
            title: "Minimal Movie",
            overview: "Minimal Overview"
        )

        let movie = mapper.map(entity)

        #expect(movie.id == 456)
        #expect(movie.title == "Minimal Movie")
        #expect(movie.tagline == nil)
        #expect(movie.overview == "Minimal Overview")
        #expect(movie.runtime == nil)
        #expect(movie.releaseDate == nil)
        #expect(movie.posterPath == nil)
        #expect(movie.backdropPath == nil)
        #expect(movie.budget == nil)
        #expect(movie.revenue == nil)
        #expect(movie.homepageURL == nil)
        #expect(movie.genres == nil)
    }

    @Test("maps with empty genres array from entity to domain")
    func mapsWithEmptyGenresArrayFromEntityToDomain() {
        let entity = MoviesMovieEntity(
            movieID: 789,
            title: "No Genres Movie",
            overview: "Overview",
            genres: []
        )

        let movie = mapper.map(entity)

        #expect(movie.genres != nil)
        #expect(movie.genres?.isEmpty == true)
    }

    // MARK: - CompactMap Tests

    @Test("compactMap returns movie when entity is not nil")
    func compactMapReturnMovieWhenEntityIsNotNil() {
        let entity = MoviesMovieEntity(
            movieID: 123,
            title: "Test Movie",
            overview: "Test Overview"
        )

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

    // MARK: - Domain to Entity Tests

    @Test("maps all properties from domain to entity")
    func mapsAllPropertiesFromDomainToEntity() {
        let movie = Movie.mock(
            id: 123,
            title: "Test Movie",
            tagline: "Test Tagline",
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
            homepageURL: URL(string: "https://example.com/movie")
        )

        let entity = mapper.map(movie)

        #expect(entity.movieID == 123)
        #expect(entity.title == "Test Movie")
        #expect(entity.tagline == "Test Tagline")
        #expect(entity.overview == "Test Overview")
        #expect(entity.runtime == 120)
        #expect(entity.releaseDate == Date(timeIntervalSince1970: 0))
        #expect(entity.posterPath == URL(string: "https://example.com/poster.jpg"))
        #expect(entity.backdropPath == URL(string: "https://example.com/backdrop.jpg"))
        #expect(entity.budget == 100_000_000)
        #expect(entity.revenue == 500_000_000)
        #expect(entity.homepageURL == URL(string: "https://example.com/movie"))
        #expect(entity.genres?.count == 2)
        #expect(entity.genres?[0].genreID == 28)
        #expect(entity.genres?[0].name == "Action")
        #expect(entity.genres?[1].genreID == 12)
        #expect(entity.genres?[1].name == "Adventure")
    }

    @Test("maps with nil optional properties from domain to entity")
    func mapsWithNilOptionalPropertiesFromDomainToEntity() {
        let movie = Movie.mock(
            id: 456,
            title: "Minimal Movie",
            tagline: nil,
            overview: "Minimal Overview",
            runtime: nil,
            genres: nil,
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil,
            budget: nil,
            revenue: nil,
            homepageURL: nil
        )

        let entity = mapper.map(movie)

        #expect(entity.movieID == 456)
        #expect(entity.title == "Minimal Movie")
        #expect(entity.tagline == nil)
        #expect(entity.overview == "Minimal Overview")
        #expect(entity.runtime == nil)
        #expect(entity.releaseDate == nil)
        #expect(entity.posterPath == nil)
        #expect(entity.backdropPath == nil)
        #expect(entity.budget == nil)
        #expect(entity.revenue == nil)
        #expect(entity.homepageURL == nil)
        #expect(entity.genres == nil)
    }

    @Test("maps with empty genres array from domain to entity")
    func mapsWithEmptyGenresArrayFromDomainToEntity() {
        let movie = Movie.mock(
            id: 789,
            title: "No Genres Movie",
            overview: "Overview",
            genres: []
        )

        let entity = mapper.map(movie)

        #expect(entity.genres != nil)
        #expect(entity.genres?.isEmpty == true)
    }

    // MARK: - Update Entity Tests

    @Test("updates existing entity with all properties")
    func updatesExistingEntityWithAllProperties() {
        let entity = MoviesMovieEntity(
            movieID: 123,
            title: "Old Title",
            overview: "Old Overview"
        )

        let movie = Movie.mock(
            id: 123,
            title: "New Title",
            tagline: "New Tagline",
            overview: "New Overview",
            runtime: 150,
            genres: [
                Genre(id: 35, name: "Comedy")
            ],
            releaseDate: Date(timeIntervalSince1970: 1_000_000),
            posterPath: URL(string: "https://example.com/new-poster.jpg"),
            backdropPath: URL(string: "https://example.com/new-backdrop.jpg"),
            budget: 200_000_000,
            revenue: 800_000_000,
            homepageURL: URL(string: "https://example.com/new-movie")
        )

        mapper.map(movie, to: entity)

        #expect(entity.title == "New Title")
        #expect(entity.tagline == "New Tagline")
        #expect(entity.overview == "New Overview")
        #expect(entity.runtime == 150)
        #expect(entity.releaseDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(entity.posterPath == URL(string: "https://example.com/new-poster.jpg"))
        #expect(entity.backdropPath == URL(string: "https://example.com/new-backdrop.jpg"))
        #expect(entity.budget == 200_000_000)
        #expect(entity.revenue == 800_000_000)
        #expect(entity.homepageURL == URL(string: "https://example.com/new-movie"))
        #expect(entity.genres?.count == 1)
        #expect(entity.genres?[0].genreID == 35)
        #expect(entity.genres?[0].name == "Comedy")
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
            genres: [
                Genre(id: 35, name: "Comedy")
            ]
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
            genres: [
                MoviesGenreEntity(genreID: 28, name: "Action")
            ]
        )

        let movie = Movie.mock(
            id: 123,
            title: "Test Movie",
            overview: "Test Overview",
            genres: nil
        )

        mapper.map(movie, to: entity)

        #expect(entity.genres?.isEmpty == true)
    }

}
