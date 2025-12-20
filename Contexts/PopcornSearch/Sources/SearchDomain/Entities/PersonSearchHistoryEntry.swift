//
//  PersonSearchHistoryEntry.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct PersonSearchHistoryEntry: Identifiable, Equatable, Sendable {

    public let id: Int
    public let timestamp: Date

    public init(
        id: Int,
        timestamp: Date = .now
    ) {
        self.id = id
        self.timestamp = timestamp
    }

}
