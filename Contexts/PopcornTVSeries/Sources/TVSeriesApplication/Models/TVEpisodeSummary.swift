//
//  TVEpisodeSummary.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

/// A summary representation of a TV episode for the application layer.
///
/// Contains resolved still image URLs via the images configuration,
/// alongside the episode's core metadata.
public struct TVEpisodeSummary: Identifiable, Equatable, Sendable {

    /// The unique identifier for the episode.
    public let id: Int

    /// The episode's name.
    public let name: String

    /// The episode's number within its season.
    public let episodeNumber: Int

    /// The season number this episode belongs to.
    public let seasonNumber: Int

    /// A brief description or summary of the episode, if available.
    public let overview: String?

    /// The date the episode first aired, if available.
    public let airDate: Date?

    /// The runtime of the episode in minutes, if available.
    public let runtime: Int?

    /// Resolved URL set for the episode's still image, if available.
    public let stillURLSet: ImageURLSet?

    public init(
        id: Int,
        name: String,
        episodeNumber: Int,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        runtime: Int? = nil,
        stillURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.runtime = runtime
        self.stillURLSet = stillURLSet
    }

}
