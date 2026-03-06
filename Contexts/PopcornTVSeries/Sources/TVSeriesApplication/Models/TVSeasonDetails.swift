//
//  TVSeasonDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

/// A TV season's details for the application layer.
///
/// Contains the season's overview text and a list of episode summaries
/// with resolved image URLs.
public struct TVSeasonDetails: Equatable, Sendable {

    /// The unique identifier for the season.
    public let id: Int

    /// Season number.
    public let seasonNumber: Int

    /// The unique identifier for the TV series.
    public let tvSeriesID: Int

    /// The localized display name of the season.
    public let name: String

    /// The name of the TV series this season belongs to.
    public let tvSeriesName: String

    /// The resolved poster image URLs for this season.
    public let posterURLSet: ImageURLSet?

    /// The season overview text, if available.
    public let overview: String?

    /// The episodes in this season.
    public let episodes: [TVEpisodeSummary]

    public init(
        id: Int,
        seasonNumber: Int,
        tvSeriesID: Int,
        name: String,
        tvSeriesName: String,
        posterURLSet: ImageURLSet? = nil,
        overview: String? = nil,
        episodes: [TVEpisodeSummary] = []
    ) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.tvSeriesID = tvSeriesID
        self.name = name
        self.tvSeriesName = tvSeriesName
        self.posterURLSet = posterURLSet
        self.overview = overview
        self.episodes = episodes
    }

}
