//
//  MovieTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameDomain
import Testing

@Suite("Movie")
struct MovieTests {

    @Test("init assigns all provided values")
    func initAssignsAllProvidedValues() throws {
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))

        let movie = Movie(
            id: 550,
            title: "Fight Club",
            overview: "An insomniac office worker...",
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
        #expect(movie.overview == "An insomniac office worker...")
        #expect(movie.posterPath == posterPath)
        #expect(movie.backdropPath == backdropPath)
    }

    @Test("init assigns nil for missing poster and backdrop paths")
    func initAssignsNilForMissingImagePaths() {
        let movie = Movie(
            id: 550,
            title: "Fight Club",
            overview: "An insomniac office worker...",
            posterPath: nil,
            backdropPath: nil
        )

        #expect(movie.posterPath == nil)
        #expect(movie.backdropPath == nil)
    }

    @Test("equality holds for movies with identical values")
    func equalityHoldsForIdenticalValues() {
        let first = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)
        let second = Movie(id: 1, title: "Movie", overview: "Overview", posterPath: nil, backdropPath: nil)

        #expect(first == second)
    }

    @Test("equality fails when overview differs")
    func equalityFailsWhenOverviewDiffers() {
        let first = Movie(id: 1, title: "Movie", overview: "Overview A", posterPath: nil, backdropPath: nil)
        let second = Movie(id: 1, title: "Movie", overview: "Overview B", posterPath: nil, backdropPath: nil)

        #expect(first != second)
    }

}
