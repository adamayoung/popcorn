//
//  MovieStatusMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("MovieStatusMapper Tests")
struct MovieStatusMapperTests {

    private let mapper = MovieStatusMapper()

    @Test("Maps rumoured status")
    func mapsRumouredStatus() {
        let result = mapper.map(.rumoured)

        #expect(result == .rumoured)
    }

    @Test("Maps planned status")
    func mapsPlannedStatus() {
        let result = mapper.map(.planned)

        #expect(result == .planned)
    }

    @Test("Maps inProduction status")
    func mapsInProductionStatus() {
        let result = mapper.map(.inProduction)

        #expect(result == .inProduction)
    }

    @Test("Maps postProduction status")
    func mapsPostProductionStatus() {
        let result = mapper.map(.postProduction)

        #expect(result == .postProduction)
    }

    @Test("Maps released status")
    func mapsReleasedStatus() {
        let result = mapper.map(.released)

        #expect(result == .released)
    }

    @Test("Maps cancelled status")
    func mapsCancelledStatus() {
        let result = mapper.map(.cancelled)

        #expect(result == .cancelled)
    }

}
