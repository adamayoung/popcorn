//
//  SearchHistorySchemaV1.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import SwiftData

package enum SearchHistorySchemaV1: VersionedSchema {

    package static let versionIdentifier = Schema.Version(1, 0, 0)

    package static let models: [any PersistentModel.Type] = [
        SearchMediaSearchHistoryEntryEntity.self
    ]

}
