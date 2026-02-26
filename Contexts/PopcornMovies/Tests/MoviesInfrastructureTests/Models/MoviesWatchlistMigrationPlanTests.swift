//
//  MoviesWatchlistMigrationPlanTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

@testable import MoviesInfrastructure
import SwiftData
import Testing

@Suite("MoviesWatchlistMigrationPlan")
struct MoviesWatchlistMigrationPlanTests {

    @Test("schemas contains only V1")
    func schemasContainsOnlyV1() {
        #expect(MoviesWatchlistMigrationPlan.schemas.count == 1)
        #expect(MoviesWatchlistMigrationPlan.schemas[0] is MoviesWatchlistSchemaV1.Type)
    }

    @Test("stages is empty for V1")
    func stagesIsEmpty() {
        #expect(MoviesWatchlistMigrationPlan.stages.isEmpty)
    }

}
