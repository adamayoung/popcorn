//
//  TVSeriesEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("TVSeriesEntityMapper Genre Tests")
struct TVSeriesEntityMapperTests {

    let mapper = TVSeriesEntityMapper()

    // MARK: - map(entity) → TVSeries — genres

    @Test("map entity to domain maps genres")
    func mapEntityToDomain_mapsGenres() {
        let entity = TVSeriesEntity.makeEntity(
            genres: [
                TVSeriesGenreEntity(genreID: 18, name: "Drama"),
                TVSeriesGenreEntity(genreID: 80, name: "Crime")
            ]
        )

        let result = mapper.map(entity)

        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].id == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].id == 80)
        #expect(result.genres?[1].name == "Crime")
    }

    @Test("map entity to domain maps nil genres")
    func mapEntityToDomain_mapsNilGenres() {
        let entity = TVSeriesEntity.makeEntity(genres: nil)

        let result = mapper.map(entity)

        #expect(result.genres == nil)
    }

    @Test("map entity to domain maps empty genres")
    func mapEntityToDomain_mapsEmptyGenres() {
        let entity = TVSeriesEntity.makeEntity(genres: [])

        let result = mapper.map(entity)

        #expect(result.genres?.isEmpty == true)
    }

    // MARK: - map(TVSeries) → entity — genres

    @Test("map domain to entity maps genres")
    func mapDomainToEntity_mapsGenres() {
        let tvSeries = TVSeries.mock(
            genres: [
                Genre(id: 18, name: "Drama"),
                Genre(id: 80, name: "Crime")
            ]
        )

        let result = mapper.map(tvSeries)

        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].genreID == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].genreID == 80)
        #expect(result.genres?[1].name == "Crime")
    }

    @Test("map domain to entity maps nil genres")
    func mapDomainToEntity_mapsNilGenres() {
        let tvSeries = TVSeries.mock(genres: nil)

        let result = mapper.map(tvSeries)

        #expect(result.genres == nil)
    }

    // MARK: - map(TVSeries, to: entity) — genres

    @Test("map domain to existing entity updates genres")
    func mapDomainToExistingEntity_updatesGenres() {
        let entity = TVSeriesEntity.makeEntity(genres: nil)
        let tvSeries = TVSeries.mock(
            genres: [
                Genre(id: 10765, name: "Sci-Fi & Fantasy"),
                Genre(id: 18, name: "Drama")
            ]
        )

        mapper.map(tvSeries, to: entity)

        #expect(entity.genres?.count == 2)
        #expect(entity.genres?[0].genreID == 10765)
        #expect(entity.genres?[0].name == "Sci-Fi & Fantasy")
        #expect(entity.genres?[1].genreID == 18)
        #expect(entity.genres?[1].name == "Drama")
    }

    @Test("map domain to existing entity clears genres when nil")
    func mapDomainToExistingEntity_clearsGenresWhenNil() {
        let entity = TVSeriesEntity.makeEntity(
            genres: [TVSeriesGenreEntity(genreID: 18, name: "Drama")]
        )
        let tvSeries = TVSeries.mock(genres: nil)

        mapper.map(tvSeries, to: entity)

        #expect(entity.genres?.isEmpty != false)
    }

    // MARK: - Round-trip

    @Test("genres survive domain to entity to domain round-trip")
    func genresSurviveRoundTrip() {
        let genres = [
            Genre(id: 18, name: "Drama"),
            Genre(id: 80, name: "Crime"),
            Genre(id: 10759, name: "Action & Adventure")
        ]
        let tvSeries = TVSeries.mock(genres: genres)

        let entity = mapper.map(tvSeries)
        let result = mapper.map(entity)

        #expect(result.genres?.count == 3)
        #expect(result.genres?[0].id == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].id == 80)
        #expect(result.genres?[1].name == "Crime")
        #expect(result.genres?[2].id == 10759)
        #expect(result.genres?[2].name == "Action & Adventure")
    }

}

extension TVSeriesEntity {

    static func makeEntity(
        tvSeriesID: Int = 1396,
        name: String = "Breaking Bad",
        tagline: String? = "All Hail the King",
        overview: String = "A chemistry teacher begins cooking meth.",
        numberOfSeasons: Int = 5,
        firstAirDate: Date? = Date(timeIntervalSince1970: 1_200_528_000),
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg"),
        genres: [TVSeriesGenreEntity]? = nil,
        seasons: [TVSeriesSeasonEntity] = []
    ) -> TVSeriesEntity {
        TVSeriesEntity(
            tvSeriesID: tvSeriesID,
            name: name,
            tagline: tagline,
            overview: overview,
            numberOfSeasons: numberOfSeasons,
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            genres: genres,
            seasons: seasons
        )
    }

}
