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
        let releaseDate = Date(timeIntervalSince1970: 908_236_800)
        let credit = TMDb.MovieCastCredit(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            releaseDate: releaseDate,
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
                releaseDate: releaseDate,
                role: .cast(character: "The Narrator")
            )
        ])
    }

    @Test("maps a TV series cast credit, using the series name and first air date")
    func mapsTVSeriesCastCredit() {
        let firstAirDate = Date(timeIntervalSince1970: 1_200_873_600)
        let credit = TMDb.TVSeriesCastCredit(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            firstAirDate: firstAirDate,
            originCountries: [],
            popularity: 200.0,
            character: "Walter White",
            creditID: "def"
        )

        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [.tvSeries(credit)], crew: []))

        #expect(result.count == 1)
        #expect(result[0].mediaType == .tvSeries)
        #expect(result[0].title == "Breaking Bad")
        #expect(result[0].releaseDate == firstAirDate)
        #expect(result[0].role == .cast(character: "Walter White"))
    }

    @Test("maps a movie crew credit, carrying the job and department")
    func mapsMovieCrewCredit() {
        let releaseDate = Date(timeIntervalSince1970: 1_279_238_400)
        let credit = TMDb.MovieCrewCredit(
            id: 27205,
            title: "Inception",
            originalTitle: "Inception",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            releaseDate: releaseDate,
            popularity: 83.5,
            job: "Director",
            department: "Directing",
            creditID: "ghi"
        )

        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [], crew: [.movie(credit)]))

        #expect(result.count == 1)
        #expect(result[0].mediaType == .movie)
        #expect(result[0].title == "Inception")
        #expect(result[0].releaseDate == releaseDate)
        #expect(result[0].role == .crew(job: "Director", department: "Directing"))
    }

    @Test("maps a TV series crew credit, carrying the job and department")
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
        #expect(result[0].role == .crew(job: "Executive Producer", department: "Production"))
        #expect(result[0].title == "Breaking Bad")
    }

    @Test("maps an empty character to nil")
    func mapsEmptyCharacterToNil() {
        let credit = TMDb.MovieCastCredit(
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

        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [.movie(credit)], crew: []))

        #expect(result[0].role == .cast(character: nil))
    }

    @Test("maps missing dates to a nil release date")
    func mapsMissingDatesToNil() {
        let cast = TMDb.MovieCastCredit(
            id: 1,
            title: "A",
            originalTitle: "A",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            character: "Hero",
            creditID: "a",
            order: 0
        )
        let crew = TMDb.TVSeriesCrewCredit(
            id: 2,
            name: "B",
            originalName: "B",
            originalLanguage: "en",
            overview: "",
            genreIDs: [],
            originCountries: [],
            job: "Director",
            department: "Directing",
            creditID: "b"
        )

        let result = mapper.map(
            TMDb.PersonCombinedCredits(id: 1, cast: [.movie(cast)], crew: [.tvSeries(crew)])
        )

        #expect(result[0].releaseDate == nil)
        #expect(result[1].releaseDate == nil)
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
            character: "Hero",
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
        #expect(result[0].role == .cast(character: "Hero"))
        #expect(result[1].role == .crew(job: "Director", department: "Directing"))
    }

    @Test("maps empty credits to an empty array")
    func mapsEmptyCredits() {
        let result = mapper.map(TMDb.PersonCombinedCredits(id: 1, cast: [], crew: []))

        #expect(result.isEmpty)
    }

}
