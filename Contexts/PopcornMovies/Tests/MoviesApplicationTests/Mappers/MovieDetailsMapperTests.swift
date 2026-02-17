//
//  MovieDetailsMapperTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import MoviesApplication
import MoviesDomain
import Testing

@Suite("MovieDetailsMapper")
struct MovieDetailsMapperTests {

    let mapper = MovieDetailsMapper()
    let imagesConfiguration: ImagesConfiguration

    init() {
        self.imagesConfiguration = ImagesConfiguration.mock()
    }

    @Test("maps core properties from movie to movie details")
    func mapsCoreProperties() {
        let result = mapFullMovie()

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.tagline == "Mischief. Mayhem. Soap.")
        #expect(result.originalTitle == "Fight Club")
        #expect(result.originalLanguage == "en")
        #expect(result.overview == "A ticking-time-bomb insomniac")
        #expect(result.runtime == 139)
        #expect(result.releaseDate == Date(timeIntervalSince1970: 939_686_400))
        #expect(result.budget == 63_000_000)
        #expect(result.revenue == 100_853_753)
        #expect(result.homepageURL == URL(string: "https://example.com/fight-club"))
        #expect(result.imdbID == "tt0137523")
        #expect(result.status == .released)
        #expect(result.originCountry == ["US"])
        #expect(result.popularity == 61.416)
        #expect(result.voteAverage == 8.433)
        #expect(result.voteCount == 27044)
        #expect(result.hasVideo == false)
        #expect(result.isAdultOnly == false)
    }

    @Test("maps genres from movie to movie details")
    func mapsGenres() {
        let result = mapFullMovie()

        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].id == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].id == 53)
        #expect(result.genres?[1].name == "Thriller")
    }

    @Test("maps production details from movie to movie details")
    func mapsProductionDetails() {
        let result = mapFullMovie()

        #expect(result.productionCompanies?.count == 1)
        #expect(result.productionCompanies?[0].id == 508)
        #expect(result.productionCompanies?[0].name == "Regency Enterprises")
        #expect(result.productionCountries?.count == 1)
        #expect(result.productionCountries?[0].countryCode == "US")
        #expect(result.spokenLanguages?.count == 1)
        #expect(result.spokenLanguages?[0].languageCode == "en")
        #expect(result.belongsToCollection?.id == 119)
        #expect(result.belongsToCollection?.name == "Fight Club Collection")
    }

    @Test("maps certification and watchlist status")
    func mapsCertificationAndWatchlist() {
        let result = mapFullMovie()

        #expect(result.certification == "18")
        #expect(result.isOnWatchlist == true)
    }

    @Test("maps image URL sets from poster and backdrop paths")
    func mapsImageURLSets() {
        let movie = Movie.mock(
            id: 1,
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )
        let imageCollection = ImageCollection(
            id: 1,
            posterPaths: [],
            backdropPaths: [],
            logoPaths: [URL(string: "/logo.jpg")].compactMap(\.self)
        )

        let result = mapper.map(
            movie,
            imageCollection: imageCollection,
            certification: nil,
            imagesConfiguration: imagesConfiguration
        )

        let expectedPosterURLSet = imagesConfiguration.posterURLSet(for: movie.posterPath)
        let expectedBackdropURLSet = imagesConfiguration.posterURLSet(for: movie.backdropPath)
        let expectedLogoURLSet = imagesConfiguration.logoURLSet(for: imageCollection.logoPaths.first)

        #expect(result.posterURLSet == expectedPosterURLSet)
        #expect(result.backdropURLSet == expectedBackdropURLSet)
        #expect(result.logoURLSet == expectedLogoURLSet)
    }

    @Test("maps nil URL sets when paths are missing")
    func mapsNilURLSetsWhenPathsAreMissing() {
        let movie = Movie.mock(id: 1, posterPath: nil, backdropPath: nil)
        let imageCollection = ImageCollection(
            id: 1,
            posterPaths: [],
            backdropPaths: [],
            logoPaths: []
        )

        let result = mapper.map(
            movie,
            imageCollection: imageCollection,
            certification: nil,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.posterURLSet == nil)
        #expect(result.backdropURLSet == nil)
        #expect(result.logoURLSet == nil)
    }

    @Test("maps nil core properties")
    func mapsNilCoreProperties() {
        let result = mapMinimalMovie()

        #expect(result.tagline == nil)
        #expect(result.originalTitle == nil)
        #expect(result.originalLanguage == nil)
        #expect(result.runtime == nil)
        #expect(result.genres == nil)
        #expect(result.releaseDate == nil)
        #expect(result.budget == nil)
        #expect(result.revenue == nil)
        #expect(result.homepageURL == nil)
        #expect(result.imdbID == nil)
        #expect(result.status == nil)
        #expect(result.originCountry == nil)
        #expect(result.popularity == nil)
        #expect(result.voteAverage == nil)
        #expect(result.voteCount == nil)
        #expect(result.hasVideo == nil)
        #expect(result.isAdultOnly == nil)
        #expect(result.certification == nil)
    }

    @Test("maps nil production properties")
    func mapsNilProductionProperties() {
        let result = mapMinimalMovie()

        #expect(result.productionCompanies == nil)
        #expect(result.productionCountries == nil)
        #expect(result.spokenLanguages == nil)
        #expect(result.belongsToCollection == nil)
    }

    @Test("defaults isOnWatchlist to false")
    func defaultsIsOnWatchlistToFalse() {
        let movie = Movie.mock(id: 1)
        let imageCollection = ImageCollection(id: 1, posterPaths: [], backdropPaths: [], logoPaths: [])

        let result = mapper.map(
            movie,
            imageCollection: imageCollection,
            certification: nil,
            imagesConfiguration: imagesConfiguration
        )

        #expect(result.isOnWatchlist == false)
    }

}

extension MovieDetailsMapperTests {

    private func mapMinimalMovie() -> MovieDetails {
        let movie = Movie.mock(
            id: 1,
            tagline: nil,
            originalTitle: nil,
            originalLanguage: nil,
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
        let imageCollection = ImageCollection(id: 1, posterPaths: [], backdropPaths: [], logoPaths: [])

        return mapper.map(
            movie,
            imageCollection: imageCollection,
            certification: nil,
            imagesConfiguration: imagesConfiguration
        )
    }

    private func mapFullMovie() -> MovieDetails {
        mapper.map(
            Self.fullMovie,
            imageCollection: Self.imageCollection,
            certification: "18",
            isOnWatchlist: true,
            imagesConfiguration: imagesConfiguration
        )
    }

    private static let fullMovie = Movie.mock(
        id: 550,
        title: "Fight Club",
        tagline: "Mischief. Mayhem. Soap.",
        originalTitle: "Fight Club",
        originalLanguage: "en",
        overview: "A ticking-time-bomb insomniac",
        runtime: 139,
        genres: [
            Genre(id: 18, name: "Drama"),
            Genre(id: 53, name: "Thriller")
        ],
        releaseDate: Date(timeIntervalSince1970: 939_686_400),
        posterPath: URL(string: "/poster.jpg"),
        backdropPath: URL(string: "/backdrop.jpg"),
        budget: 63_000_000,
        revenue: 100_853_753,
        homepageURL: URL(string: "https://example.com/fight-club"),
        imdbID: "tt0137523",
        status: .released,
        productionCompanies: [
            ProductionCompany(id: 508, name: "Regency Enterprises", originCountry: "US")
        ],
        productionCountries: [
            ProductionCountry(countryCode: "US", name: "United States of America")
        ],
        spokenLanguages: [
            SpokenLanguage(languageCode: "en", name: "English")
        ],
        originCountry: ["US"],
        belongsToCollection: MovieCollection(id: 119, name: "Fight Club Collection"),
        popularity: 61.416,
        voteAverage: 8.433,
        voteCount: 27044,
        hasVideo: false,
        isAdultOnly: false
    )

    private static let imageCollection = ImageCollection(
        id: 550,
        posterPaths: [],
        backdropPaths: [],
        logoPaths: [URL(string: "/logo.jpg")].compactMap(\.self)
    )

}
