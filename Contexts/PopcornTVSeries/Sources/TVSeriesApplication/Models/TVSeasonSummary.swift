//
//  TVSeasonSummary.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

/// A single season within a TV series in the application model.
///
/// `TVSeasonSummary` is the application-layer representation of a season,
/// with the poster image resolved to an absolute `URL` via the images configuration.
public struct TVSeasonSummary: Identifiable, Equatable, Sendable {

    /// The unique identifier for the season.
    public let id: Int

    /// The localized display name of the season.
    public let name: String

    /// The season's number within its TV series (e.g., 1 for the first season).
    public let seasonNumber: Int

    /// Resolved URL set for the season's poster image, if available.
    public let posterURLSet: ImageURLSet?

    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        posterURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.seasonNumber = seasonNumber
        self.posterURLSet = posterURLSet
    }

}
