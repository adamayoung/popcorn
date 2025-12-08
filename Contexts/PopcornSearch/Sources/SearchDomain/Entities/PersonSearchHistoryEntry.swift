//
//  PersonSearchHistoryEntry.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
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
