//
//  TVSeason.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a single season within a TV series in the domain model.
///
/// A `TVSeason` contains the metadata for an individual season of a show,
/// including its identifier, display name, season number in the series,
/// and an optional poster image path.
///
public struct TVSeason: Identifiable, Equatable, Sendable {

    /// The unique identifier for the season.
    public let id: Int

    /// The localized display name of the season.
    public let name: String

    /// The season's number within its TV series (e.g., 1 for the first season).
    public let seasonNumber: Int

    /// URL path to the season's poster image, if available.
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
