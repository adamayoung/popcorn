//
//  PersonCreditMapperTests.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain
@testable import PopcornPeopleAdapters
import Testing
import TMDb

@Suite("PersonCreditMapper Tests")
struct PersonCreditMapperTests {

    let mapper = PersonCreditMapper()

    @Test("maps a movie cast credit")
    func mapsMovieCastCredit() throws {
        let backdrop = try #require(URL(string: "/backdrop.jpg"))
        let poster = try #require(URL(string: "/poster.jpg"))
        let credit = TMDb.MovieCastCredit(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            posterPath: poster,
            backdropPath: backdrop,
            popularity: 61.4,
            character: "The Narrator",
            creditID: "abc",
            order: 0
        )

        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [.movie(credit)], crew: []))

        #expect(result == [
            PersonCredit(
                id: 550,
                mediaType: .movie,
                title: "Fight Club",
                backdropPath: backdrop,
                posterPath: poster,
                popularity: 61.4,
                role: .cast
            )
        ])
    }

    @Test("maps a TV series cast credit, using the series name as the title")
    func mapsTVSeriesCastCredit() {
        let credit = TMDb.TVSeriesCastCredit(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            originCountries: [],
            popularity: 200.0,
            character: "Walter White",
            creditID: "def"
        )

        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [.tvSeries(credit)], crew: []))

        #expect(result.count == 1)
        #expect(result[0].mediaType == .tvSeries)
        #expect(result[0].title == "Breaking Bad")
        #expect(result[0].role == .cast)
    }

    @Test("maps a movie crew credit, carrying the department")
    func mapsMovieCrewCredit() {
        let credit = TMDb.MovieCrewCredit(
            id: 27205,
            title: "Inception",
            originalTitle: "Inception",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            popularity: 83.5,
            job: "Director",
            department: "Directing",
            creditID: "ghi"
        )

        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [], crew: [.movie(credit)]))

        #expect(result.count == 1)
        #expect(result[0].mediaType == .movie)
        #expect(result[0].title == "Inception")
        #expect(result[0].role == .crew(department: "Directing"))
    }

    @Test("maps a TV series crew credit, carrying the department")
    func mapsTVSeriesCrewCredit() {
        let credit = TMDb.TVSeriesCrewCredit(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            originCountries: [],
            popularity: 200.0,
            job: "Executive Producer",
            department: "Production",
            creditID: "jkl"
        )

        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [], crew: [.tvSeries(credit)]))

        #expect(result.count == 1)
        #expect(result[0].role == .crew(department: "Production"))
        #expect(result[0].title == "Breaking Bad")
    }

    @Test("concatenates cast and crew credits")
    func concatenatesCastAndCrew() {
        let cast = TMDb.MovieCastCredit(
            id: 1,
            title: "A",
            originalTitle: "A",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            character: "",
            creditID: "a",
            order: 0
        )
        let crew = TMDb.MovieCrewCredit(
            id: 2,
            title: "B",
            originalTitle: "B",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            job: "Director",
            department: "Directing",
            creditID: "b"
        )

        let result = mapper.map(
            TMDb.PersonCombinedCredits(id: 1, cast: [.movie(cast)], crew: [.movie(crew)])
        )

        #expect(result.map(\.id) == [1, 2])
        #expect(result[0].role == .cast)
        #expect(result[1].role == .crew(department: "Directing"))
    }

    @Test("maps empty credits to an empty array")
    func mapsEmptyCredits() {
        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [], crew: []))

        #expect(result.isEmpty)
    }

}
