//
//  MovieSearchHistoryEntry.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct MovieSearchHistoryEntry: Identifiable, Equatable, Sendable {

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
