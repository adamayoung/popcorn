//
//  SearchHistorySchemaV1Tests.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

@testable import SearchInfrastructure
import SwiftData
import Testing

@Suite("SearchHistorySchemaV1")
struct SearchHistorySchemaV1Tests {

    @Test("version identifier is 1.0.0")
    func versionIdentifierIs1_0_0() {
        #expect(SearchHistorySchemaV1.versionIdentifier == Schema.Version(1, 0, 0))
    }

    @Test("models contains SearchMediaSearchHistoryEntryEntity")
    func modelsContainsSearchHistoryEntity() {
        #expect(SearchHistorySchemaV1.models.count == 1)
        #expect(SearchHistorySchemaV1.models.first is SearchMediaSearchHistoryEntryEntity.Type)
    }

}
