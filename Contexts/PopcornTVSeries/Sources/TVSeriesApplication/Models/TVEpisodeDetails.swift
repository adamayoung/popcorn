//
//  TVEpisodeDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

/// A representation of a TV episode for the application layer.
///
/// Contains resolved still image URLs via the images configuration,
/// alongside the episode's core metadata.
public struct TVEpisodeDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the episode.
    public let id: Int

    /// The episode's name.
    public let name: String

    /// The episode's number within its season.
    public let episodeNumber: Int

    /// The season number this episode belongs to.
    public let seasonNumber: Int

    /// The unique identifier for the season.
    public let tvSeasonID: Int

    /// The unique identifier for the series.
    public let tvSeriesID: Int

    /// The season's name.
    public let tvSeasonName: String

    /// The series' name.
    public let tvSeriesName: String

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
        tvSeasonID: Int,
        tvSeriesID: Int,
        tvSeasonName: String,
        tvSeriesName: String,
        overview: String? = nil,
        airDate: Date? = nil,
        runtime: Int? = nil,
        stillURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.tvSeasonID = tvSeasonID
        self.tvSeriesID = tvSeriesID
        self.tvSeasonName = tvSeasonName
        self.tvSeriesName = tvSeriesName
        self.overview = overview
        self.airDate = airDate
        self.runtime = runtime
        self.stillURLSet = stillURLSet
    }

}
