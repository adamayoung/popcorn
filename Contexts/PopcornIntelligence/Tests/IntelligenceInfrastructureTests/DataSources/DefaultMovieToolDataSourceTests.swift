//
//  DefaultMovieToolDataSourceTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
@testable import IntelligenceInfrastructure
import Testing

@Suite("DefaultMovieToolDataSource")
struct DefaultMovieToolDataSourceTests {

    let mockMovieProvider: MockMovieProvider
    let mockCreditsProvider: MockCreditsProvider
    let dataSource: DefaultMovieToolDataSource

    init() {
        self.mockMovieProvider = MockMovieProvider()
        self.mockCreditsProvider = MockCreditsProvider()
        self.dataSource = DefaultMovieToolDataSource(
            movieProvider: mockMovieProvider,
            creditsProvider: mockCreditsProvider
        )
    }

    @Test("movie returns MovieTool")
    func movieReturnsMovieTool() {
        let tool = dataSource.movie()

        #expect(tool.name == "fetchMovieDetails")
        #expect(tool.description == "Fetch details about a movie.")
    }

    @Test("movieCredits returns MovieCreditsTool")
    func movieCreditsReturnsMovieCreditsTool() {
        let tool = dataSource.movieCredits()

        #expect(tool.name == "fetchMovieCredits")
        #expect(tool.description == "Fetch the top listed credits (cast and crew) of a movie.")
    }

}
