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
/// an optional poster image path, an optional overview, and its episodes.
///
/// When used as a child of ``TVSeries``, episodes and overview are typically
/// not populated. When fetched via ``TVSeasonRepository``, all fields
/// including episodes are populated.
///
public struct TVSeason: Identifiable, Equatable, Sendable {

    /// The unique identifier for the season.
    public let id: Int

    /// The localized display name of the season.
    public let name: String

    /// The season's number within its TV series (e.g., 1 for the first season).
    public let seasonNumber: Int

    /// A brief description or summary of the season, if available.
    public let overview: String?

    /// URL path to the season's poster image, if available.
    public let posterPath: URL?

    /// The episodes in this season.
    public let episodes: [TVEpisode]

    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        overview: String? = nil,
        posterPath: URL? = nil,
        episodes: [TVEpisode] = []
    ) {
        self.id = id
        self.name = name
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.posterPath = posterPath
        self.episodes = episodes
    }

}
