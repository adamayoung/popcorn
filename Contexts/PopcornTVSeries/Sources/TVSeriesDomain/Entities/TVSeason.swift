//
//  TVSeason.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVSeason: Identifiable, Equatable, Sendable {

    public let id: Int

    public let name: String

    public let seasonNumber: Int

    public let posterPath: URL?

    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        posterPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.seasonNumber = seasonNumber
        self.posterPath = posterPath
    }

}
