//
//  DiskCacheEntry.swift
//  Caching
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct DiskCacheEntry: Codable {

    let expiresAt: Date?
    let data: Data

    var isExpired: Bool {
        guard let expiresAt else {
            return false
        }

        return expiresAt < Date()
    }

}
