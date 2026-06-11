//
//  EPGSyncStateEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

///
/// A singleton row recording when the local cache was last successfully synced.
/// Drives the sync throttle. `key` is fixed and unique so there is only ever one row.
/// (Avoid naming a stored property `id` — it collides with the `@Model`-synthesised
/// `PersistentIdentifier`-backed identifier and crashes on the SQLite store.)
///
@Model
final class EPGSyncStateEntity: Equatable {

    @Attribute(.unique) var key: String
    var lastSyncedAt: Date?

    init(key: String = EPGSyncStateEntity.singletonKey, lastSyncedAt: Date? = nil) {
        self.key = key
        self.lastSyncedAt = lastSyncedAt
    }

    static let singletonKey = "singleton"

}
