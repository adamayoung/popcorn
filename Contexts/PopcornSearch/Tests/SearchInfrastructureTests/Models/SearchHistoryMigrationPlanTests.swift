//
//  SearchHistoryMigrationPlanTests.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

@testable import SearchInfrastructure
import SwiftData
import Testing

@Suite("SearchHistoryMigrationPlan")
struct SearchHistoryMigrationPlanTests {

    @Test("schemas contains only V1")
    func schemasContainsOnlyV1() {
        #expect(SearchHistoryMigrationPlan.schemas.count == 1)
        #expect(SearchHistoryMigrationPlan.schemas.first is SearchHistorySchemaV1.Type)
    }

    @Test("stages is empty for V1")
    func stagesIsEmpty() {
        #expect(SearchHistoryMigrationPlan.stages.isEmpty)
    }

}
