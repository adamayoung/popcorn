//
//  EPGFileStateEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

///
/// The locally-stored content hash of a single EPG file (e.g. `channels.json` or
/// `schedules/20260611.json`). Compared against the manifest to skip unchanged files.
/// (The property is `contentHash`, not `hash`, to avoid shadowing `NSObject.hash`, which
/// is an integer and crashes the SQLite store when read as a `String`.)
///
@Model
final class EPGFileStateEntity: Equatable {

    @Attribute(.unique) var path: String
    var contentHash: String

    init(path: String, contentHash: String) {
        self.path = path
        self.contentHash = contentHash
    }

}
