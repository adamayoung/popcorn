//
//  MovieMapperTests.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain
@testable import PlotRemixGameFeature
import Testing

@Suite("MovieMapper Tests")
struct MovieMapperTests {

    private let mapper = MovieMapper()

    @Test("Maps Movie with all properties")
    func mapsMovieWithAllProperties() {
        let domainMovie = PlotRemixGameDomain.Movie(
            id: 118,
            title: "Charlie and the Chocolate Factory",
            overview: "A young boy wins a tour through the chocolate factory.",
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )

        let result = mapper.map(domainMovie)

        #expect(result.id == 118)
        #expect(result.title == "Charlie and the Chocolate Factory")
        #expect(result.overview == "A young boy wins a tour through the chocolate factory.")
        #expect(result.posterPath == URL(string: "/poster.jpg"))
        #expect(result.backdropPath == URL(string: "/backdrop.jpg"))
    }

    @Test("Maps Movie with nil paths")
    func mapsMovieWithNilPaths() {
        let domainMovie = PlotRemixGameDomain.Movie(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            posterPath: nil,
            backdropPath: nil
        )

        let result = mapper.map(domainMovie)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.overview == "Test overview")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("Maps multiple movies correctly")
    func mapsMultipleMovies() {
        let movie1 = PlotRemixGameDomain.Movie(
            id: 1,
            title: "Movie 1",
            overview: "Overview 1",
            posterPath: nil,
            backdropPath: nil
        )
        let movie2 = PlotRemixGameDomain.Movie(
            id: 2,
            title: "Movie 2",
            overview: "Overview 2",
            posterPath: nil,
            backdropPath: nil
        )

        let results = [movie1, movie2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].title == "Movie 1")
        #expect(results[1].id == 2)
        #expect(results[1].title == "Movie 2")
    }

}
