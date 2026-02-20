//
//  TVSeasonDetailsSummary.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A summary of a TV season's details for the application layer.
///
/// Contains the season's overview text and a list of episode summaries
/// with resolved image URLs.
public struct TVSeasonDetailsSummary: Equatable, Sendable {

    /// The season overview text, if available.
    public let overview: String?

    /// The episodes in this season.
    public let episodes: [TVEpisodeSummary]

    public init(
        overview: String? = nil,
        episodes: [TVEpisodeSummary] = []
    ) {
        self.overview = overview
        self.episodes = episodes
    }

}
