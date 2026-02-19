//
//  TVSeasonSummary.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVSeasonSummary: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let seasonNumber: Int
    public let posterURL: URL?

    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.seasonNumber = seasonNumber
        self.posterURL = posterURL
    }

}
